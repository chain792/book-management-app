# EngineerBook - 開発ガイド

## プロジェクト概要
ITエンジニア向け技術書レビューアプリ。Rails 8.1.1 + PostgreSQL + Hotwire。

## 開発環境

### Docker Compose構成
- `app`: Railsアプリ (port 3000)
- `db`: PostgreSQL 18 (port 5433→5432)
- `selenium_chrome`: System spec用ブラウザ

### よく使うコマンド
```bash
# テスト実行（Docker内）
docker compose exec app bundle exec rspec
docker compose exec app bundle exec rspec spec/system/
docker compose exec app bundle exec rspec spec/components/

# Sorbet型チェック
docker compose exec app bundle exec srb tc

# DB操作
docker compose run --rm app bin/rails db:migrate:reset db:seed
```

## コーディング規約

### Sorbet
- **コンポーネント / ヘルパー**: `# typed: strict` + 全メソッドに `sig`
- **コントローラ**: `# typed: true` + 全メソッドに `sig`（ivarの `T.let` 問題のため strict にしない）
- **モデル**: `# typed: true` + カスタムメソッドに `sig`
- ログインユーザーは `current_user!`（非nil保証）を使う
- リソース取得はGetterパターン: `sig { returns(Book) } def current_book` → `@book = current_book`
- 詳細: `docs/sorbet.md`

### ViewComponent
- `ApplicationComponent` (`app/components/application_component.rb`) を継承
- `# typed: strict` + keyword引数 + private attr_reader with sig
- テンプレートは `.html.erb`
- render: `<%= render ComponentName.new(param: value) %>`
- 参照実装: `app/components/book_card_component.rb`
- 詳細: `docs/components.md`

```ruby
# typed: strict
class ExampleComponent < ApplicationComponent
  sig { params(book: Book).void }
  def initialize(book:)
    @book = book
  end

  private

  sig { returns(Book) }
  attr_reader :book
end
```

### 認証
- `allow_unauthenticated_access` を使用（`skip_before_action :require_authentication` は使わない）
- 定義元: `app/controllers/concerns/authentication.rb`

### デザイン
- モダンスタイル: `glass`, `brand-*`, `rounded-[2rem]`, `font-black`, `tracking-tight`
- 旧スタイル（`bg-white border rounded-xl`等）は使わない
- UIコンポーネント（`Ui::ButtonComponent`等）を積極的に使用

### テスト
- system spec: Docker内で実行（`docker compose exec app bundle exec rspec spec/system/`）
- component spec: `render_inline` + `expect(page)` パターン
- ファクトリ: `spec/factories/` に各モデル用あり
- ログインヘルパー: `login_as(user)` (system spec), `login_user(user)` (request spec)

## アーキテクチャ

### ディレクトリ構成
```
app/
  components/          # ViewComponent（typed: strict）
    ui/                # 汎用UIコンポーネント（Button, Form系）
  controllers/         # Rails controllers（typed: true）
    concerns/          # Authentication等
  models/              # ActiveRecord models
  views/               # ERBテンプレート
    likes/             # Turbo Stream templates
    relationships/     # Turbo Stream templates
docs/
  teams/               # チーム別タスク定義
spec/
  components/          # コンポーネントspec
  system/              # Capybara system spec
  requests/            # Request spec
  factories/           # FactoryBot定義
```

### Turbo Stream パターン
いいね・フォローなどリアルタイム更新は Turbo Stream で処理。コンポーネントのルート要素に `id` を付与し、turbo_stream.erb から `turbo_stream.replace` でコンポーネントを再描画する。

```erb
<%# likes/create.turbo_stream.erb %>
<%= turbo_stream.replace dom_id(@book, :like_button) do %>
  <%= render LikeButtonComponent.new(book: @book, current_user: current_user) %>
<% end %>
```

## チーム開発

現在のリファクタリング計画は `docs/teams/` に配置。各チームのタスク定義を参照のこと。
- `docs/teams/README.md` — 全体構成と依存関係

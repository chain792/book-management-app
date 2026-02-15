# システム仕様書

## プロジェクト概要
技術書のレビュー・管理を行う Rails アプリケーション。

## 技術スタック
- **Framework**: Rails 8.1.1
- **Language**: Ruby 3.4.0 (Docker)
- **Database**: PostgreSQL (18-alpine)
- **Frontend**: Hotwire (Turbo, Stimulus), CSSBundling (Tailwind)
- **Type Check**: Sorbet (strict for components, true for controllers/models)
- **UI**: ViewComponent
- **Testing**: RSpec, Capybara (Selenium Chrome), FactoryBot

## 主要なモジュール

### 認証 (Authentication)
Rails 8 の組み込み認証を使用 (`app/controllers/concerns/authentication.rb`)。
- **モデル**: `User`, `Session`
- **主要機能**: `Current` を使ったカレントユーザー管理、Cookie ベースのセッション管理。
- **OAuth**: Twitter 連携 (`omniauth-twitter`) が実装済み。
- **アクセス制御**: `allow_unauthenticated_access` でログイン不要なアクションを指定。

### データモデル
- `User`: ユーザー情報、アバター(Shrine)、自己紹介。role: general/guest
- `Book`: 書籍情報、タイトル、レビュー内容、カテゴリ。Google Books API連携
- `Author`: 著者情報（BookAuthor経由でBook多対多）
- `Category`: 技術書のカテゴリ（Ancestry による階層構造）
- `Comment`: 本に対するコメント
- `Like`: 本に対するお気に入り機能
- `Relationship`: ユーザー間のフォロー機能（active_relationships / passive_relationships）

### ルーティング
```
root                    books#index
resources :users        new, create, show + following, follower
resources :books        CRUD + search (Google Books API)
  resources :comments   create, update, destroy (shallow)
resources :categories   index, show
resources :likes        create, destroy
resources :relationships create, destroy
resource  :profile      show, edit, update
sessions                login, logout, guest_login
passwords               CRUD (token-based reset)
oauths                  create, failure (Twitter OAuth)
static_pages            terms, privacy
```

## 開発環境 (Docker Compose)
- `app`: Rails アプリ本体。ポート 3000
- `db`: PostgreSQL。ポート 5433 (Host) → 5432 (Container)
- `selenium_chrome`: System spec用ブラウザ (`seleniarm/standalone-chromium`)

### コマンド
```bash
# アプリ起動
docker compose up

# テスト
docker compose exec app bundle exec rspec
docker compose exec app bundle exec rspec spec/system/

# 型チェック
docker compose exec app bundle exec srb tc

# DB リセット
docker compose run --rm app bin/rails db:migrate:reset db:seed
```

## ディレクトリ構成
```
app/
  components/              # ViewComponent (typed: strict)
    ui/                    # 汎用UIコンポーネント
      form/                # フォーム系コンポーネント
  controllers/             # Controllers (typed: true)
    concerns/              # Authentication
  models/                  # ActiveRecord models
    concerns/              # BookAttachments, UserAttachments
  views/
    layouts/               # application.html.erb
    books/                 # CRUD views + search
    comments/              # パーシャル + turbo_stream
    likes/                 # turbo_stream templates
    relationships/         # turbo_stream templates
    profiles/              # show, edit
    users/                 # new, show, following, follower
    sessions/              # login form
    shared/                # 共通パーシャル
  helpers/                 # ApplicationHelper (typed: strict)
  uploaders/               # ImageUploader (Shrine)
  javascript/controllers/  # Stimulus controllers
config/
  routes.rb
docs/
  components.md            # ViewComponent仕様
  sorbet.md                # Sorbet型定義ルール
  system_specification.md  # 本ファイル
  teams/                   # チーム別リファクタリングタスク
spec/
  components/              # コンポーネントspec
  system/                  # Capybara system spec (8ファイル, 42テスト)
  requests/                # Request spec
  models/                  # Model spec
  factories/               # FactoryBot定義
  support/                 # ヘルパー (login_macros, capybara設定)
sorbet/
  config                   # Sorbet設定
  rbi/                     # RBIファイル (annotations, dsl, shims)
    shims/models/          # belongs_to 非nil化shim
```

---
name: view-component
description: ViewComponentの作成パターンとコンポーネント一覧。コンポーネントの新規作成・修正・テンプレート編集時に自動参照。
user-invocable: false
---

# ViewComponent ルール

## 作成パターン

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

- `ApplicationComponent` を継承（`app/components/application_component.rb`）
- `# typed: strict` + keyword引数 + private attr_reader with sig
- テンプレートは `.html.erb`
- render: `<%= render ComponentName.new(param: value) %>`
- spec: `spec/components/` に `render_inline` + `expect(page)` パターン
- 参照実装: `app/components/book_card_component.rb`

## ApplicationComponent

- 継承元: `ViewComponent::Base`
- include: `ActionView::Helpers::AssetTagHelper`, `ActionView::Helpers::UrlHelper`, `ActionView::RecordIdentifier`

## デザイン規約

- UI コンポーネント（`Ui::ButtonComponent` 等）を積極的に使用

## コンポーネント一覧

### レイアウト
- `HeaderComponent` — ヘッダー（ガラスモーフィズム、スティッキー）
- `FooterComponent` — フッター（著作権、リンク）
- `FlashComponent` — 通知メッセージ（success/danger/info）

### ブック関連
- `BookCardComponent` — 本カード（props: `book: Book`）
- `BookDetailsComponent` — 本詳細（props: `book: Book`）
- `GoogleBookCardComponent` — Google Books検索結果（props: `google_book: T::Hash`）
- `TwitterShareComponent` — Twitterシェアリンク（props: `book: Book, url: String`）

### ユーザー・プロフィール
- `ProfileHeaderComponent` — プロフィールヘッダー（props: `user: User`）
- `UserCardComponent` — ユーザーカード（props: `user: User, current_user: T.nilable(User)`）

### インタラクション
- `CommentComponent` — コメント（props: `comment: Comment, current_user: T.nilable(User)`）
- `ErrorMessageComponent` — バリデーションエラー（props: `object: T.untyped`、render?で判定）
- `LikeButtonComponent` — いいねボタン Turbo Stream対応（props: `book: Book, current_user: T.nilable(User)`）
- `FollowButtonComponent` — フォローボタン Turbo Stream対応（props: `user: User, current_user: T.nilable(User)`）

### UI Atomic（`app/components/ui/`）
- `Ui::ButtonComponent` — ボタン（variant: primary/secondary/danger, size: sm/md/lg）
- `Ui::Form::LabelComponent` — フォームラベル
- `Ui::Form::InputComponent` — テキスト入力
- `Ui::Form::TextAreaComponent` — 複数行入力
- `Ui::Form::SelectComponent` — プルダウン選択

## Turbo Stream パターン

コンポーネントのルート要素に `id` を付与し、turbo_stream.erb から `turbo_stream.replace` で再描画:

```erb
<%# likes/create.turbo_stream.erb %>
<%= turbo_stream.replace dom_id(@book, :like_button) do %>
  <%= render LikeButtonComponent.new(book: @book, current_user: current_user) %>
<% end %>
```

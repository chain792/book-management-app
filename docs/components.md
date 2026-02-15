# ViewComponent Documentation

このプロジェクトでは、UIの一貫性と保守性を高めるために `ViewComponent` を導入しています。

## 新規コンポーネント作成手順

1. `app/components/` に `.rb` と `.html.erb` を作成
2. `ApplicationComponent` を継承
3. `# typed: strict` + 全メソッドに `sig` を付与
4. keyword引数 + private `attr_reader` with sig
5. `spec/components/` にspecを作成（`render_inline` + `expect(page)`）

```ruby
# typed: strict
class NewComponent < ApplicationComponent
  sig { params(model: Model).void }
  def initialize(model:)
    @model = model
  end

  private

  sig { returns(Model) }
  attr_reader :model
end
```

## 共通ベースコンポーネント

### `ApplicationComponent`
全てのコンポーネントの基底クラスです。Sorbetによる型チェックが有効になっており、ヘルパーメソッドへのアクセスを提供します。
- **ファイル**: `app/components/application_component.rb`
- **継承元**: `ViewComponent::Base`
- **include**: `ActionView::Helpers::AssetTagHelper`, `ActionView::Helpers::UrlHelper`, `ActionView::RecordIdentifier`

---

## レイアウト・ナビゲーション

### `HeaderComponent`
アプリケーションの上部に表示されるヘッダーです。ガラスモーフィズムのデザインが適用されており、スティッキー（固定）表示されます。
- **機能**: ロゴ、ナビゲーション、ログインユーザー向けのドロップダウンメニュー、新規投稿ボタン。

### `FlashComponent`
画面上部に表示される一時的な通知メッセージ（成功、エラーなど）です。
- **デザイン**: 右上にフローティングで表示され、数秒後に消えるスタイリッシュなデザイン。

---

## ブック関連コンポーネント

### `BookCardComponent`
投稿された本の概要を表示するカード型のコンポーネントです。
- **props**: `book: Book`
- **特徴**: ホバー時のアニメーション、統計情報（いいね、コメント数）の表示。

### `GoogleBookCardComponent`
Google Books検索結果を表示するためのコンパクトなコンポーネントです。
- **props**: `google_book: T::Hash`
- **特徴**: 検索結果から直接詳細を確認できるボタン。

### `BookDetailsComponent`
本の詳細ページで使用される、大きな情報表示コンポーネントです。
- **props**: `book: Book`
- **特徴**: 本のカバー画像、タイトル、著者、およびアクションボタンのレイアウト。

---

## ユーザー・プロフィール

### `ProfileHeaderComponent`
ユーザーのプロフィールページ上部に表示されるヘッダーです。
- **props**: `user: User`
- **特徴**: アバター、統計（フォロー/フォロワー数）、紹介文、編集ボタン。

---

## インタラクション

### `CommentComponent`
コメントスレッド内の各コメントを表示します。
- **props**: `comment: Comment`, `current_user: T.nilable(User)`
- **特徴**: ユーザーが自分のコメントである場合の編集・削除ドロップダウン。

---

## UI Atomic Components (`app/components/ui/`)

これらはデザインを統一するための最小単位のコンポーネントです。

### `Ui::ButtonComponent`
ボタンやボタン風のリンクを標準化します。
- **props**:
  - `variant`: `primary`, `secondary`, `danger` (Default: `primary`)
  - `size`: `sm`, `md`, `lg` (Default: `md`)
  - `type`: `button`, `submit` (Default: `button`)
  - `class_names`: 追加のCSSクラス

### `Ui::Form::LabelComponent`
フォームのラベルを標準化します。
- **props**: `form`, `field`, `text`, `class_names`

### `Ui::Form::InputComponent`
テキスト入力入力を標準化します。
- **props**: `form`, `field`, `type` (`text`, `email`, `password` etc.), `placeholder`, `class_names`

### `Ui::Form::TextAreaComponent`
複数行入力を標準化します。
- **props**: `form`, `field`, `rows`, `placeholder`, `class_names`

### `Ui::Form::SelectComponent`
プルダウン選択を標準化します。カスタムアローのデザインが含まれます。
- **props**: `form`, `field`, `choices`, `options`, `html_options`

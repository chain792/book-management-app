# Team F: コンポーネントspec作成

## 依存関係
- **全チーム（A〜E）の完了が必要**（全コンポーネントが揃ってからspecを書く）

## 目的
全ViewComponentのユニットテストを作成する。

## セットアップ

`spec/components/` ディレクトリを作成。ViewComponentの `render_inline` を使用。

### specの基本パターン
```ruby
# typed: false
require "rails_helper"

RSpec.describe BookCardComponent, type: :component do
  let(:book) { create(:book) }

  it "タイトルが表示される" do
    render_inline(described_class.new(book: book))
    expect(page).to have_text(book.title)
  end
end
```

---

## specファイル一覧（18ファイル）

### 既存コンポーネント（12ファイル）

#### 1. `spec/components/header_component_spec.rb`
テスト項目:
- ログイン時: ユーザー名が表示される、ドロップダウンメニューが存在する
- 未ログイン時: ログインリンクが表示される、アカウント作成ボタンが表示される

#### 2. `spec/components/flash_component_spec.rb`
テスト項目:
- flash[:success] でsuccessメッセージが表示される
- flash[:danger] でdangerメッセージが表示される
- flash[:info] でinfoメッセージが表示される
- flashが空の場合、何もレンダリングされない（render? = false）

#### 3. `spec/components/profile_header_component_spec.rb`
テスト項目:
- ユーザー名が表示される
- メールアドレスが表示される（一般ユーザー）
- ゲストユーザーの場合、メールアドレスが表示されない
- 自己紹介が表示される
- フォロー数/フォロワー数が表示される
- 「編集する」ボタンが表示される

#### 4. `spec/components/book_card_component_spec.rb`
テスト項目:
- 本のタイトルが表示される
- 著者名が表示される
- カテゴリ名が表示される
- ユーザー名が表示される
- 本詳細へのリンクが存在する

#### 5. `spec/components/book_details_component_spec.rb`
テスト項目:
- 本のタイトルが表示される
- 著者一覧が表示される
- 自分の投稿: 編集/削除メニューが表示される
- 他人の投稿: 編集/削除メニューが表示されない
- カテゴリのパンくずリストが表示される

#### 6. `spec/components/comment_component_spec.rb`
テスト項目:
- コメント本文が表示される
- 投稿者名が表示される
- 自分のコメント: ドロップダウン（編集/削除）が表示される
- 他人のコメント: ドロップダウンが表示されない

#### 7. `spec/components/google_book_card_component_spec.rb`
テスト項目:
- 本のタイトルが表示される
- 著者名が表示される
- 新規投稿リンクが存在する

#### 8. `spec/components/ui/button_component_spec.rb`
テスト項目:
- primary variant: 正しいCSSクラスが適用される
- secondary variant: 正しいCSSクラスが適用される
- danger variant: 正しいCSSクラスが適用される
- ブロックコンテンツがレンダリングされる

#### 9. `spec/components/ui/form/input_component_spec.rb`
テスト項目:
- input要素がレンダリングされる
- name属性が正しく設定される
- type属性が正しく設定される（text, email, password）

#### 10. `spec/components/ui/form/label_component_spec.rb`
テスト項目:
- label要素がレンダリングされる
- for属性が正しく設定される

#### 11. `spec/components/ui/form/select_component_spec.rb`
テスト項目:
- select要素がレンダリングされる
- 選択肢が正しく表示される

#### 12. `spec/components/ui/form/text_area_component_spec.rb`
テスト項目:
- textarea要素がレンダリングされる
- name属性が正しく設定される

### 新規コンポーネント（6ファイル）

#### 13. `spec/components/error_message_component_spec.rb`
テスト項目:
- エラーがある場合: エラーメッセージが表示される
- エラーがない場合: 何もレンダリングされない（render? = false）

#### 14. `spec/components/footer_component_spec.rb`
テスト項目:
- 著作権表示が表示される
- 現在年が表示される
- 利用規約、プライバシー、お問い合わせリンクが存在する

#### 15. `spec/components/twitter_share_component_spec.rb`
テスト項目:
- Twitterシェアリンクが存在する
- リンクURLにbook情報が含まれる

#### 16. `spec/components/like_button_component_spec.rb`
テスト項目:
- いいね済み: unlike-buttonが表示される（`data-testid="unlike-button"`）
- 未いいね: like-buttonが表示される（`data-testid="like-button"`）
- 未ログイン: like-buttonが表示される
- いいね数が表示される（1以上の場合）

#### 17. `spec/components/follow_button_component_spec.rb`
テスト項目:
- フォロー中: 「フォロー中」ボタンが表示される
- 未フォロー: 「フォロー」ボタンが表示される
- 自分自身: レンダリングされない（render? = false）
- 未ログイン: レンダリングされない（render? = false）

#### 18. `spec/components/user_card_component_spec.rb`
テスト項目:
- ユーザー名が表示される
- 自己紹介が表示される
- アバター画像が表示される
- ユーザー詳細へのリンクが存在する

---

## 検証

```bash
# コンポーネントspecのみ
docker compose exec app bundle exec rspec spec/components/

# 全体
docker compose exec app bundle exec rspec
```

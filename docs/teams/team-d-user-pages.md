# Team D: ユーザーページのモダンデザイン化

## 依存関係
- **Team Cの完了が必要**（FollowButtonComponentを使用するため）
- Team Aで削除しなかった `_book.html.erb`, `_user.html.erb` はこのチームで対応後に削除

## 目的
`users/show.html.erb`, `following.html.erb`, `follower.html.erb` を他のページと統一されたモダンデザインに書き換え、旧パーシャルをViewComponentに置換する。

## デザイン参照
モダンデザインの参照先（これらに合わせる）:
- `app/views/profiles/show.html.erb` — glass, brand-*, rounded-[3rem] スタイル
- `app/components/profile_header_component.html.erb` — ユーザー情報の表示パターン
- `app/components/book_card_component.html.erb` — カード型の本表示

---

## タスク1: UserCardComponent 作成

### 現在の旧パーシャル (`app/views/users/_user.html.erb`)
```erb
<div class="bg-white border rounded-lg p-4 mb-2 relative min-w-[300px] hover:shadow-md transition">
  <div class="flex items-center">
    <%= image_tag user.avatar_url || "default_avatar.png", size: '60x60', class: 'rounded-full mr-3 ml-3' %>
    <div class="flex flex-col md:flex-row md:items-center md:space-x-3">
      <h3 class="text-lg font-semibold"><%= user.name %></h3>
      <%= render 'relationships/follow_button', user: user %>
    </div>
  </div>
  <div class="pt-3">
    <p class="border-b text-sm font-semibold mb-2">自己紹介</p>
    <p class="text-sm text-gray-700"><%= user.introduction&.truncate(50) %></p>
  </div>
  <%= link_to '', user_path(user), class: 'absolute inset-0' %>
</div>
```

### 作成するファイル

**`app/components/user_card_component.rb`:**
```ruby
# typed: strict

class UserCardComponent < ApplicationComponent
  sig { params(user: User, current_user: T.nilable(User)).void }
  def initialize(user:, current_user:)
    @user = user
    @current_user = current_user
  end

  private

  sig { returns(User) }
  attr_reader :user

  sig { returns(T.nilable(User)) }
  attr_reader :current_user

  sig { returns(String) }
  def avatar_url
    user.avatar_url.presence || "default_avatar.png"
  end

  sig { returns(T.nilable(String)) }
  def introduction_text
    user.introduction&.truncate(80)
  end
end
```

**`app/components/user_card_component.html.erb`:**
- モダンデザイン（glass, brand-*, rounded-2xl）で作成
- FollowButtonComponentを内部でrender
- ユーザー名、アバター、自己紹介（truncate）を表示
- カード全体がリンクになるように `link_to` でラップ

---

## タスク2: `users/show.html.erb` モダンデザイン化

### 現状（旧デザイン）
- `bg-white border rounded-xl` スタイル
- `render 'books/book', book: book` で旧カード使用
- `render 'relationships/follow_button', user: @user` で旧パーシャル使用

### 変更内容
- 全体をモダンデザイン（glass, brand-*, rounded-[2rem]等）に書き換え
- `render 'books/book', book: book` → `render BookCardComponent.new(book: book)` に置換
- `render 'relationships/follow_button', user: @user` → `render FollowButtonComponent.new(user: @user, current_user: current_user)` に置換
- レイアウト参考: `app/views/profiles/show.html.erb` と `app/components/profile_header_component.html.erb`

### system specが検証するコンテンツ（変更してはいけないテキスト）
`spec/system/users_spec.rb` より:
- `others.name` — ユーザー名が表示される
- `others.introduction` — 自己紹介が表示される
- `book_1.title`, `book_2.title` — 投稿した本のタイトルが表示される
- 「フォロー」ボタン — `have_button('フォロー')` で検索される
- フォロー数/フォロワー数のリンク先: `following_user_path`, `follower_user_path`

---

## タスク3: `following.html.erb` / `follower.html.erb` モダンデザイン化

### 現状
```erb
<%= render @users %>
```
Railsのコレクションレンダリングで `_user.html.erb` を使用。

### 変更内容
- `render @users` → 明示的ループ + UserCardComponent:
  ```erb
  <% @users.each do |user| %>
    <%= render UserCardComponent.new(user: user, current_user: current_user) %>
  <% end %>
  ```
- ページ全体をモダンデザインに
- ヘッダー部分にユーザー名表示を維持

### system specが検証するコンテンツ
`spec/system/relationships_spec.rb` より:
- `my_following_user.name` — フォロー一覧にユーザー名が表示される
- `me.name` — フォロワー一覧にユーザー名が表示される

---

## タスク4: 旧ファイル削除

タスク1-3完了後に削除:
- `app/views/users/_user.html.erb`
- `app/views/books/_book.html.erb`

---

## 検証

```bash
docker compose exec app bundle exec rspec spec/system/users_spec.rb spec/system/relationships_spec.rb
```

全テストがパスすること。特に:
- ユーザー詳細表示（名前、自己紹介、投稿した本の一覧）
- フォロー/フォロー解除の動作
- フォロー一覧/フォロワー一覧の表示

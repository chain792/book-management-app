# Team C: Turbo Stream対応 ViewComponent変換

## 依存関係
なし（即時着手可能）
ただし `book_details_component.html.erb` はTeam Bのタスク3(TwitterShare)と競合するため、Team Bのタスク3の後に作業すること。

## 目的
Turbo Streamで動的更新されるLikeボタンとFollowボタンをViewComponentに変換する。

## 重要ポイント
- コンポーネントのルート要素に `id` 属性を付与し、Turbo Streamの `replace` ターゲットにする
- turbo_streamテンプレートからもコンポーネントをrenderする
- `current_user` はビューヘルパーから取得可能（turbo_streamテンプレートでもアクセス可能）

---

## タスク1: LikeButtonComponent

### 現状の3パーシャル

**`app/views/likes/_like_button.html.erb`** (コンテナ):
```erb
<div id="<%= dom_id(book, :like_button) %>">
  <% if authenticated? && current_user.like?(book) %>
    <%= render 'likes/like', book: book %>
  <% else %>
    <%= render 'likes/unlike', book: book %>
  <% end %>
</div>
```

**`app/views/likes/_like.html.erb`** (いいね済み = 解除ボタン):
```erb
<%= link_to like_path(current_user.likes.find { |v| v.book_id == book.id }),
            data: { turbo_method: :delete, testid: "unlike-button" },
            class: "group flex items-center space-x-2 text-rose-500 hover:scale-110 transition-transform" do %>
  <svg class="w-6 h-6 fill-current" viewBox="0 0 24 24">
    <path d="M11.645 20.91l-.007-.003-..." />
  </svg>
  <span class="text-sm font-black text-brand-900"><%= book.likes.length unless book.likes.length.zero? %></span>
<% end %>
```

**`app/views/likes/_unlike.html.erb`** (未いいね = いいねボタン):
```erb
<%= link_to likes_path(book_id: book.id),
            data: { turbo_method: :post, testid: "like-button" },
            class: "group flex items-center space-x-2 text-brand-300 hover:text-rose-500 hover:scale-110 transition-all" do %>
  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l..." />
  </svg>
  <span class="text-sm font-bold text-brand-400 group-hover:text-brand-900 transition-colors"><%= book.likes.length unless book.likes.length.zero? %></span>
<% end %>
```

### 作成するファイル

**`app/components/like_button_component.rb`:**
```ruby
# typed: strict

class LikeButtonComponent < ApplicationComponent
  sig { params(book: Book, current_user: T.nilable(User)).void }
  def initialize(book:, current_user:)
    @book = book
    @current_user = current_user
  end

  private

  sig { returns(Book) }
  attr_reader :book

  sig { returns(T.nilable(User)) }
  attr_reader :current_user

  sig { returns(T::Boolean) }
  def liked?
    return false unless current_user
    current_user.like?(book)
  end

  sig { returns(String) }
  def dom_id_value
    helpers.dom_id(book, :like_button)
  end

  sig { returns(Integer) }
  def likes_count
    book.likes.length
  end

  sig { returns(T::Boolean) }
  def show_count?
    likes_count > 0
  end

  # いいね済みの場合のlike_pathを返す
  sig { returns(T.nilable(String)) }
  def unlike_path
    return nil unless current_user
    like = current_user.likes.find { |v| v.book_id == book.id }
    like ? helpers.like_path(like) : nil
  end
end
```

**`app/components/like_button_component.html.erb`:**
- ルート要素: `<div id="<%= dom_id_value %>">`
- liked? で条件分岐してunlikeボタン / likeボタンを表示
- `data-testid="unlike-button"` / `data-testid="like-button"` を維持（system specが依存）

### 変更するファイル

1. **`app/components/book_details_component.html.erb`** L86:
   ```erb
   # Before
   <%= render 'likes/like_button', book: book %>
   # After
   <%= render LikeButtonComponent.new(book: book, current_user: current_user) %>
   ```

2. **`app/views/likes/create.turbo_stream.erb`**:
   ```erb
   <%= turbo_stream.replace dom_id(@book, :like_button) do %>
     <%= render LikeButtonComponent.new(book: @book, current_user: current_user) %>
   <% end %>
   ```

3. **`app/views/likes/destroy.turbo_stream.erb`**: 同上

### 削除するファイル
- `app/views/likes/_like_button.html.erb`
- `app/views/likes/_like.html.erb`
- `app/views/likes/_unlike.html.erb`

### 検証
```bash
docker compose exec app bundle exec rspec spec/system/likes_spec.rb
```
- `data-testid="like-button"` / `data-testid="unlike-button"` でのクリックが正常に動作すること
- Turbo Streamでのリアルタイム切り替えが機能すること

---

## タスク2: FollowButtonComponent

### 現状の3パーシャル

**`app/views/relationships/_follow_button.html.erb`** (コンテナ):
```erb
<% if authenticated? && current_user != user %>
  <div id="follow-button-for-user-<%= user.id %>" class="ms-3">
    <% if current_user.follow? user %>
      <%= render 'relationships/follow', user: user %>
    <% else %>
      <%= render 'relationships/unfollow', user: user %>
    <% end %>
  </div>
<% end %>
```

**`app/views/relationships/_follow.html.erb`** (フォロー中 = 解除ボタン):
```erb
<%= button_to 'フォロー中',
    relationship_path(current_user.active_relationships.find { |v| v.follower_id == user.id }),
    method: :delete,
    class: 'inline-flex items-center rounded-full bg-gray-200 px-4 py-1 text-sm font-medium text-gray-700 hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-300' %>
```

**`app/views/relationships/_unfollow.html.erb`** (未フォロー = フォローボタン):
```erb
<%= button_to 'フォロー',
    relationships_path(follower_id: user.id),
    class: 'inline-flex items-center rounded-full bg-blue-600 px-4 py-1 text-sm font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300' %>
```

### 作成するファイル

**`app/components/follow_button_component.rb`:**
```ruby
# typed: strict

class FollowButtonComponent < ApplicationComponent
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

  # 自分自身 or 未ログインなら描画しない
  sig { returns(T::Boolean) }
  def render?
    current_user.present? && current_user != user
  end

  sig { returns(T::Boolean) }
  def following?
    return false unless current_user
    current_user.follow?(user)
  end

  sig { returns(String) }
  def dom_id_value
    "follow-button-for-user-#{user.id}"
  end

  # フォロー解除用のrelationship_pathを返す
  sig { returns(T.nilable(String)) }
  def unfollow_path
    return nil unless current_user
    relationship = current_user.active_relationships.find { |v| v.follower_id == user.id }
    relationship ? helpers.relationship_path(relationship) : nil
  end
end
```

**`app/components/follow_button_component.html.erb`:**
- ルート要素: `<div id="<%= dom_id_value %>">`
- following? で条件分岐
- ボタンテキスト「フォロー」「フォロー中」を維持（system specが依存）

### 変更するファイル

1. **`app/views/users/show.html.erb`** L13:
   ```erb
   # Before
   <%= render 'relationships/follow_button', user: @user %>
   # After
   <%= render FollowButtonComponent.new(user: @user, current_user: current_user) %>
   ```

2. **`app/views/relationships/create.turbo_stream.erb`**:
   ```erb
   <%= turbo_stream.replace "follow-button-for-user-#{@user.id}" do %>
     <%= render FollowButtonComponent.new(user: @user, current_user: current_user) %>
   <% end %>
   ```

3. **`app/views/relationships/destroy.turbo_stream.erb`**: 同上

### 削除するファイル
- `app/views/relationships/_follow_button.html.erb`
- `app/views/relationships/_follow.html.erb`
- `app/views/relationships/_unfollow.html.erb`

### 検証
```bash
docker compose exec app bundle exec rspec spec/system/relationships_spec.rb
```
- 「フォロー」ボタンクリック → 「フォロー中」に変化すること
- 「フォロー中」クリック → 「フォロー」に変化すること
- 自分のページにはフォローボタンが表示されないこと

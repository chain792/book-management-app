# Team B: シンプルなViewComponent変換

## 依存関係
なし（即時着手可能）

## 目的
Turbo Streamを使わない3つのパーシャルをViewComponentに変換する。

## 共通パターン

全コンポーネントはこのパターンに従うこと:

```ruby
# typed: strict

class ExampleComponent < ApplicationComponent
  sig { params(param: Type).void }
  def initialize(param:)
    @param = param
  end

  private

  sig { returns(Type) }
  attr_reader :param
end
```

参照実装: `app/components/book_card_component.rb`

---

## タスク1: ErrorMessageComponent

### 現状
`app/views/shared/_error_message.html.erb` が6箇所で使用中:
```erb
<%= render 'shared/error_message', object: f.object %>
```

### 現在のパーシャル内容
```erb
<% if object.errors.any? %>
  <div id="error-message" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-md mb-4">
    <ul class="list-disc list-inside space-y-1 m-0">
      <% object.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
    </ul>
  </div>
<% end %>
```

### 作成するファイル
- `app/components/error_message_component.rb`
  - `initialize(object:)` — `T.untyped` （ActiveModelオブジェクト）
  - `render?` メソッドで `object.errors.any?` を判定（テンプレートからif文を除去）
- `app/components/error_message_component.html.erb`
  - 上記HTMLから `<% if ... %>` / `<% end %>` を除いたもの

### 変更するファイル（6箇所）
全箇所で `render 'shared/error_message', object: f.object` → `render ErrorMessageComponent.new(object: f.object)` に変更:

1. `app/views/profiles/edit.html.erb`
2. `app/views/users/new.html.erb`
3. `app/views/books/edit.html.erb`
4. `app/views/books/new.html.erb`
5. `app/views/comments/_edit_form.html.erb`
6. `app/views/comments/_form.html.erb`

### 削除するファイル
- `app/views/shared/_error_message.html.erb`

---

## タスク2: FooterComponent

### 現状
`app/views/shared/_footer.html.erb` が `app/views/layouts/application.html.erb` で使用中。

### 現在のパーシャル内容
```erb
<footer class="mt-20 border-t border-brand-100 bg-white">
  <div class="max-w-7xl mx-auto px-6 py-12">
    <div class="flex flex-col md:flex-row items-center justify-between gap-8">
      <div class="flex items-center space-x-2 text-brand-900 group">
        <div class="w-8 h-8 bg-brand-900 rounded-lg flex items-center justify-center text-white scale-90 group-hover:scale-100 transition-transform">
          <svg ...>...</svg>
        </div>
        <span class="text-lg font-black tracking-tighter uppercase">Engineer Book Reviews</span>
      </div>
      <p class="text-[10px] font-bold text-brand-300 uppercase tracking-widest text-center">
        &copy; <%= Time.zone.now.year %> Designed for the developer community.
      </p>
      <div class="flex items-center space-x-8">
        <%= link_to '利用規約', terms_path, class: '...' %>
        <%= link_to 'プライバシー', privacy_path, class: '...' %>
        <%= link_to 'お問い合わせ', 'https://docs.google.com/forms/...', class: '...' %>
      </div>
    </div>
  </div>
</footer>
```

### 作成するファイル
- `app/components/footer_component.rb`
  - `initialize` — 引数なし (`sig { void }`)
  - private `current_year` メソッド
- `app/components/footer_component.html.erb`
  - `Time.zone.now.year` → `current_year` に置換

### 変更するファイル
- `app/views/layouts/application.html.erb` — `render 'shared/footer'` → `render FooterComponent.new`

### 削除するファイル
- `app/views/shared/_footer.html.erb`

---

## タスク3: TwitterShareComponent

### 現状
`app/views/books/_twitter_share.html.erb` が `app/components/book_details_component.html.erb` L95で使用中。

### 現在のパーシャル内容
```erb
<%= link_to "https://twitter.com/intent/tweet?url=#{request.url}&hashtags=EnginnerBook&text=#{book.body.truncate(30)}",
            target: :_blank,
            class: "inline-flex items-center text-sky-500 hover:text-sky-600 transition-colors" do %>
  <i class="bi bi-twitter text-xl"></i>
<% end %>
```

### 作成するファイル
- `app/components/twitter_share_component.rb`
  - `initialize(book:, url:)` — `request.url` への依存を除去し、URLを引数で受け取る
  - private `share_url` メソッドでTwitter Intent URLを組み立て
  - private `share_text` メソッド
- `app/components/twitter_share_component.html.erb`

### 変更するファイル
- `app/components/book_details_component.html.erb` L95:
  ```erb
  # Before
  <%= render 'books/twitter_share', book: book %>
  # After
  <%= render TwitterShareComponent.new(book: book, url: helpers.book_url(book)) %>
  ```
- `app/components/book_details_component.rb` — 必要に応じて `book_url` ヘルパーを使えるか確認（ApplicationComponentでActionView::Helpers::UrlHelperをinclude済み）

### 削除するファイル
- `app/views/books/_twitter_share.html.erb`

---

## 検証

各タスク完了後:
```bash
docker compose exec app bundle exec rspec spec/system/
```

特に確認すべきspec:
- タスク1: `spec/system/users_spec.rb`, `spec/system/profiles_spec.rb`, `spec/system/books_spec.rb`, `spec/system/comments_spec.rb`
- タスク2: 全system spec（レイアウト変更のため）
- タスク3: `spec/system/books_spec.rb`

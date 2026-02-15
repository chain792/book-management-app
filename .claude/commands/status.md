リファクタリングの進捗状況を確認する。

## 手順

1. `docs/teams/README.md` を読んでチーム構成と依存関係を把握する

2. 各チームの完了状況を以下で判定:

### Team A (Cleanup)
- 以下のファイルが削除されているか確認:
  - `app/views/shared/_header.html.erb`
  - `app/views/shared/_flash_message.html.erb`
  - `app/views/shared/_sidebar.html.erb`
  - `app/views/shared/_before_login_header.html.erb`
  - `app/views/comments/_comment.html.erb`

### Team B (Simple Components)
- 以下のファイルが存在するか確認:
  - `app/components/error_message_component.rb`
  - `app/components/footer_component.rb`
  - `app/components/twitter_share_component.rb`
- 旧パーシャルが削除されているか確認:
  - `app/views/shared/_error_message.html.erb`
  - `app/views/shared/_footer.html.erb`
  - `app/views/books/_twitter_share.html.erb`

### Team C (Interactive Components)
- 以下のファイルが存在するか確認:
  - `app/components/like_button_component.rb`
  - `app/components/follow_button_component.rb`
- 旧パーシャルが削除されているか確認:
  - `app/views/likes/_like_button.html.erb`
  - `app/views/likes/_like.html.erb`
  - `app/views/likes/_unlike.html.erb`
  - `app/views/relationships/_follow_button.html.erb`
  - `app/views/relationships/_follow.html.erb`
  - `app/views/relationships/_unfollow.html.erb`

### Team D (User Pages)
- 以下のファイルが存在するか確認:
  - `app/components/user_card_component.rb`
- 旧パーシャルが削除されているか確認:
  - `app/views/users/_user.html.erb`
  - `app/views/books/_book.html.erb`
- `app/views/users/show.html.erb` でモダンデザイン（`glass`, `brand-*`）が使われているか確認

### Team E (Sorbet Controllers)
- 全コントローラで `allow_unauthenticated_access` が使われているか（`skip_before_action :require_authentication` が残っていないか）
- 全コントローラに `extend T::Sig` があるか
- publicメソッドに `sig { void }` があるか

### Team F (Component Specs)
- `spec/components/` 配下にspecファイルが存在するか

3. 結果を表形式で報告:
   | チーム | ステータス | 残タスク |

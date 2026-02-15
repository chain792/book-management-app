# Team A: 不要ファイル削除

## 依存関係
なし（即時着手可能）

## 目的
ViewComponentに置換済みだが削除されていない旧パーシャルや、どこからも参照されていないファイルを削除する。

## タスク

以下のファイルを削除する:

| ファイル | 理由 |
|----------|------|
| `app/views/shared/_header.html.erb` | `HeaderComponent` に置換済み。参照なし |
| `app/views/shared/_flash_message.html.erb` | `FlashComponent` に置換済み。参照なし |
| `app/views/shared/_sidebar.html.erb` | どこからも参照なし |
| `app/views/shared/_before_login_header.html.erb` | どこからも参照なし |
| `app/views/comments/_comment.html.erb` | `CommentComponent` に置換済み。`_comments.html.erb` は CommentComponent を使用中 |

## 注意事項

- `app/views/books/_book.html.erb` はまだ `users/show.html.erb` L44 で使用中 → **Team Dが対応するまで削除しない**
- `app/views/users/_user.html.erb` はまだ `following.html.erb` / `follower.html.erb` で `render @users` 経由で使用中 → **Team Dが対応するまで削除しない**

## 検証

```bash
docker compose exec app bundle exec rspec
```

全42テストがパスすること。

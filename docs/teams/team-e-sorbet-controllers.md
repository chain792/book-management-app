# Team E: 認証パターン統一 + コントローラSorbet sig追加

## 依存関係
なし（即時着手可能）

## 目的
1. 認証パターンを `allow_unauthenticated_access` に統一
2. 全コントローラに `extend T::Sig` + メソッドsigを追加

---

## タスク1: 認証パターン統一

`Authentication` concern（`app/controllers/concerns/authentication.rb`）で定義済みの `allow_unauthenticated_access` に統一する。

### 変更箇所

| ファイル | Before | After |
|----------|--------|-------|
| `app/controllers/books_controller.rb` L6 | `skip_before_action :require_authentication, only: %i[index show]` | `allow_unauthenticated_access only: %i[index show]` |
| `app/controllers/categories_controller.rb` L3 | `skip_before_action :require_authentication, only: %i[show]` | `allow_unauthenticated_access only: %i[show]` |
| `app/controllers/static_pages_controller.rb` L3 | `skip_before_action :require_authentication` | `allow_unauthenticated_access` |

### 変更不要（既に統一済み）
- `app/controllers/users_controller.rb` — `allow_unauthenticated_access` 使用中
- `app/controllers/sessions_controller.rb` — 同上
- `app/controllers/passwords_controller.rb` — 同上
- `app/controllers/oauths_controller.rb` — 同上

### 注意
- `ApplicationController` L7 の `before_action :require_authentication` は `Authentication` concern の `included` ブロックで設定されている。ただし、Authentication concern を確認して重複がないか確認のこと。現在の `authentication.rb` L13: `before_action :require_authentication` があるか確認し、重複している場合は `ApplicationController` 側を削除。

---

## タスク2: 全コントローラにsig追加

### 方針
- `# typed: true` は維持（controllerはivar代入が多く `typed: strict` だと `T.let` が大量に必要になるため）
- `extend T::Sig` を追加（未設定のもの）
- 全public/privateメソッドに `sig` ブロックを追加

### コントローラ別の作業内容

#### `app/controllers/application_controller.rb`
- `extend T::Sig` 追加
- `after_authentication_url` に `sig { returns(String) }` 追加

#### `app/controllers/static_pages_controller.rb`
- `extend T::Sig` 追加
- `top`, `terms`, `privacy` に `sig { void }` 追加

#### `app/controllers/users_controller.rb`
- `extend T::Sig` 追加
- 全メソッドにsig追加:
  - `index`, `new`, `create`, `show`, `following`, `follower` → `sig { void }`
  - `user_params` → `sig { returns(ActionController::Parameters) }`
  - `set_user` → `sig { void }`

#### `app/controllers/categories_controller.rb`
- `extend T::Sig` 追加
- `index`, `show` → `sig { void }`

#### `app/controllers/sessions_controller.rb`（`extend T::Sig` 済み）
- `new`, `create`, `destroy`, `guest_login` → `sig { void }` 追加

#### `app/controllers/books_controller.rb`（`extend T::Sig` 済み、private sigあり）
- public: `index`, `new`, `create`, `show`, `edit`, `update`, `destroy`, `search` → `sig { void }` 追加

#### `app/controllers/comments_controller.rb`（`extend T::Sig` 済み、private sigあり）
- public: `create`, `update`, `destroy` → `sig { void }` 追加

#### `app/controllers/likes_controller.rb`（`extend T::Sig` 済み）
- `create`, `destroy` → `sig { void }` 追加

#### `app/controllers/relationships_controller.rb`（`extend T::Sig` 済み）
- `create`, `destroy` → `sig { void }` 追加

#### `app/controllers/profiles_controller.rb`（`extend T::Sig` 済み、private sigあり）
- public: `show`, `edit`, `update` → `sig { void }` 追加

#### `app/controllers/oauths_controller.rb`（`extend T::Sig` 済み）
- `create`, `failure` → `sig { void }` 追加

#### `app/controllers/passwords_controller.rb`（`extend T::Sig` 済み、private sigあり）
- public: `new`, `create`, `edit`, `update` → `sig { void }` 追加

---

## 検証

```bash
# Rspec
docker compose exec app bundle exec rspec

# Sorbet型チェック
docker compose exec app bundle exec srb tc
```

全テストパス + Sorbetエラーなしを確認。

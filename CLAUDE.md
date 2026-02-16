# EngineerBook - 開発ガイド

## プロジェクト概要
ITエンジニア向け技術書レビューアプリ。Rails 8.1.1 + PostgreSQL + Hotwire。

## 開発環境

### Docker Compose構成
- `app`: Railsアプリ (port 3000)
- `db`: PostgreSQL 18 (port 5433→5432)
- `selenium_chrome`: System spec用ブラウザ

### よく使うコマンド
```bash
# テスト実行（Docker内）
docker compose exec app bundle exec rspec
docker compose exec app bundle exec rspec spec/system/
docker compose exec app bundle exec rspec spec/components/

# Sorbet型チェック
docker compose exec app bundle exec srb tc

# DB操作
docker compose run --rm app bin/rails db:migrate:reset db:seed
```

## コーディング規約

詳細ルールは `.claude/skills/` に定義（自動参照される）:
- **Sorbet**: `.claude/skills/sorbet/SKILL.md`
- **ViewComponent**: `.claude/skills/view-component/SKILL.md`

### 認証
- `allow_unauthenticated_access` を使用（`skip_before_action :require_authentication` は使わない）
- 定義元: `app/controllers/concerns/authentication.rb`

### テスト
- system spec: Docker内で実行（`docker compose exec app bundle exec rspec spec/system/`）
- component spec: `render_inline` + `expect(page)` パターン
- ファクトリ: `spec/factories/` に各モデル用あり
- ログインヘルパー: `login_as(user)` (system spec), `login_user(user)` (request spec)

# システム仕様書

## プロジェクト概要
技術書のレビュー・管理を行う Rails アプリケーション。

## 技術スタック
- **Framework**: Rails 8.1.1
- **Language**: Ruby 3.4.0 (Docker)
- **Database**: PostgreSQL (18-alpine)
- **Frontend**: Hotwire (Turbo, Stimulus), CSSBundling (Tailwind/Vanilla)
- **Testing**: RSpec, Capybara (Selenium Chrome)

## 主要なモジュール
### 認証 (Authentication)
Rails 8 の組み込み認証を使用 (`rails g authentication` 生成ベース)。
- **モデル**: `User`, `Session`
- **主要機能**: `Current` を使ったカレントユーザー管理、Cookie ベースのセッション管理。
- **OAuth**: Twitter 連携 (`omniauth-twitter`) が実装済み。

### データモデル
- `User`: ユーザー情報、アバター、自己紹介。
- `Book`: 書籍情報、タイトル、レビュー内容、カテゴリ。
- `Author`: 著者情報。
- `Category`: 技術書のカテゴリ（Ancestry による階層構造）。
- `Comment`: 本に対するコメント。
- `Like`: 本に対するお気に入り機能。
- `Relationship`: ユーザー間のフォロー機能。

## 開発環境 (Docker)
- `app`: Rails アプリ本体。ポート 3000。
- `db`: PostgreSQL。ポート 5433 (Host)。
- `selenium_chrome`: システムテスト用。

## ディレクトリ構成（主要部分）
- `app/controllers`: 認証用 `SessionsController` や `UsersController`、業務用の `BooksController` 等。
- `app/models`: 各種 ActiveRecord モデル。
- `app/views`: ERB テンプレート。ViewComponent 導入により順次リプレース予定。
- `docs/`: 本仕様書、実施計画書、タスク管理。

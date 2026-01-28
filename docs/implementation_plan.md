# リファクタリング実施計画書 (Phase 2-4)

本ドキュメントでは、認証機能移行後のリファクタリング（Sorbet, Trailblazer, ViewComponent）の計画を記述します。

## 1. Sorbet による型定義の導入 (Phase 2)
Rails アプリケーションに静的型チェックを導入し、堅牢性を高めます。

### 導入ステップ
1. Gem の追加: `sorbet`, `sorbet-runtime`, `tapioca` (開発環境用)。
2. `srb init` による初期化。
3. `tapioca init` を実行し、Gem や Rails 構造の RBI ファイルを生成。
4. モデル、コントローラから順次 `# typed: true` に上げ、エラーを修正。
5. `sig` を用いた型定義の追加。

## 2. Trailblazer の導入 (Phase 3)
複雑になりがちなビジネスロジックをコントローラやモデルから分離し、`Operation` に集約します。

### 導入ステップ
1. Gem の追加: `trailblazer-rails`, `trailblazer-cells` (必要に応じて)。
2. 認証後の「本の検索・登録」フローを `Operation` として再定義。
3. コントローラを `endpoint` または単純な呼び出しのみに簡略化。

## 3. ViewComponent への移行 (Phase 4)
Ruby オブジェクトとしての View 部品を作成し、テスタビリティと再利用性を向上させます。

### 導入ステップ
1. Gem の追加: `view_component`。
2. `app/components` ディレクトリの構成。
3. `Shared` 配下のコンポーネント（エラーメッセージ、ナビゲーションバー）から移行。
4. システムテストによる表示確認。

## 4. 検証計画
- **自動テスト**: `docker compose run --rm app bundle exec rspec` を各フェーズの完了後に実行。
- **型チェック**: `docker compose run --rm app bundle exec srb tc` を実行。
- **システムテスト**: ブラウザ実行による UI 崩れの確認（ViewComponent 導入時）。

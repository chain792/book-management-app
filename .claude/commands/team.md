チームタスクを実行する。

引数: $ARGUMENTS（チーム名: a, b, c, d, e, f）

## 手順

1. `docs/teams/README.md` を読んで全体の依存関係を把握する
2. 指定されたチームのタスクファイルを読む:
   - a → `docs/teams/team-a-cleanup.md`
   - b → `docs/teams/team-b-simple-components.md`
   - c → `docs/teams/team-c-interactive-components.md`
   - d → `docs/teams/team-d-user-pages.md`
   - e → `docs/teams/team-e-sorbet-controllers.md`
   - f → `docs/teams/team-f-component-specs.md`
3. `CLAUDE.md` を読んでコーディング規約を確認する
4. タスクファイルに記載された作業を順番に実行する
5. 各ステップ完了後に `docker compose exec app bundle exec rspec` でテストを実行して確認する
6. Sorbetの型チェックが関係するタスクの場合は `docker compose exec app bundle exec srb tc` も実行する

## 注意事項
- 依存するチームのタスクが完了していることを確認してから開始すること
- テストが通らない場合はテストが通るまで修正すること
- `docs/sorbet.md` と `docs/components.md` の規約に従うこと

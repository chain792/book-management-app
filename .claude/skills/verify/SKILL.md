---
name: verify
description: テストと型チェックを実行してプロジェクトの健全性を確認する。/verify で実行。
user-invocable: true
allowed-tools: Bash
---

# プロジェクト検証

テストとSorbet型チェックを実行し、結果をサマリとして報告する。

## 手順

1. テストとSorbet型チェックを並列実行:
   ```
   docker compose exec app bundle exec rspec --format progress
   ```
   ```
   docker compose exec app bundle exec srb tc
   ```

2. 結果をサマリとして報告:
   - examples数、failures数
   - Sorbetエラーの有無と内容
   - 失敗がある場合は原因の簡易分析

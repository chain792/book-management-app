---
name: verify
description: テストと型チェックを実行してプロジェクトの健全性を確認する。/verify で実行。
user-invocable: true
allowed-tools: Bash
---

# プロジェクト検証

テストとSorbet型チェックを実行し、結果をサマリとして報告する。

## 手順

1. system specを実行:
   ```
   docker compose exec app bundle exec rspec spec/system/ --format documentation
   ```

2. component specを実行:
   ```
   docker compose exec app bundle exec rspec spec/components/ --format documentation
   ```

3. request specを実行:
   ```
   docker compose exec app bundle exec rspec spec/requests/ --format documentation
   ```

4. model specを実行:
   ```
   docker compose exec app bundle exec rspec spec/models/ --format documentation
   ```

5. Sorbet型チェックを実行:
   ```
   docker compose exec app bundle exec srb tc
   ```

6. 結果をサマリとして報告する:
   - 各specの pass/fail 数
   - Sorbetエラーの有無
   - 失敗がある場合は原因の簡易分析

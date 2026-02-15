新しいViewComponentを作成する。

引数: $ARGUMENTS（コンポーネント名とprops。例: `LikeButtonComponent book:Book current_user:T.nilable(User)`）

## 手順

1. `CLAUDE.md` と `docs/components.md` を読んでコーディング規約を確認する
2. 参照実装として `app/components/book_card_component.rb` と対応する `.html.erb` を読む
3. 引数で指定されたコンポーネント名とpropsに基づいて以下を作成:
   - `app/components/{snake_case_name}.rb` — `# typed: strict`, `ApplicationComponent` 継承, keyword引数, private attr_reader with sig
   - `app/components/{snake_case_name}.html.erb` — テンプレート
   - `spec/components/{snake_case_name}_spec.rb` — `render_inline` を使ったspec
4. `docker compose exec app bundle exec rspec spec/components/{snake_case_name}_spec.rb` でテストを実行
5. `docker compose exec app bundle exec srb tc` で型チェックを実行

## ルール
- Ui名前空間のコンポーネントは `app/components/ui/` 配下に配置
- Form系は `app/components/ui/form/` 配下
- specは必ず作成すること

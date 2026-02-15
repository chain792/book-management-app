# リファクタリング チーム分け

## 概要

SorbetとViewComponentのリファクタリングを完了させるため、6チームに分けて並行作業する。

## チーム構成と依存関係

```
[並行実行可能]
  Team A: Cleanup           ──────────────┐
  Team B: Simple Components ──────────────┤
  Team C: Interactive Components ─┬───────┤
  Team E: Sorbet Controllers ─────┤       │
                                  │       │
[Team C完了後]                     │       │
  Team D: User Pages ─────────────┘       │
                                          │
[全チーム完了後]                            │
  Team F: Component Specs ────────────────┘
```

## 実行フロー

### Wave 1（並行実行）
| チーム | 内容 | 推定規模 |
|--------|------|----------|
| Team A | 不要ファイル削除 | 小 |
| Team B | ErrorMessage / Footer / TwitterShare Component作成 | 中 |
| Team C | LikeButton / FollowButton Component作成（Turbo Stream対応） | 大 |
| Team E | 認証パターン統一 + コントローラsig追加 | 中 |

### Wave 2（Team C完了後）
| チーム | 内容 | 推定規模 |
|--------|------|----------|
| Team D | UserCardComponent + ユーザーページのモダンデザイン化 | 大 |

### Wave 3（全チーム完了後）
| チーム | 内容 | 推定規模 |
|--------|------|----------|
| Team F | 全コンポーネントのspec作成（18ファイル） | 大 |

## 推奨モデル

| チーム | 推奨モデル | 理由 |
|--------|------------|------|
| Team A | **Haiku** | ファイル削除のみ。判断不要 |
| Team B | **Sonnet** | パターンに従うComponent作成。参照実装あり |
| Team C | **Opus** | Turbo Stream連携、dom_id整合、data-testid維持など判断が多い |
| Team D | **Opus** | デザイン判断 + 複数ファイル横断の整合性が必要 |
| Team E | **Sonnet** | 機械的なsig追加。パターンが明確 |
| Team F | **Sonnet** | `render_inline` パターンの繰り返し。量は多いが定型 |

## 共通ルール

- 全ViewComponentは `ApplicationComponent` (`app/components/application_component.rb`) を継承
- 全コンポーネントは `# typed: strict` + 完全なsig付き
- パターン参照: `app/components/book_card_component.rb`
- 各チーム作業完了後に `docker compose exec app bundle exec rspec` で全テスト通過を確認
- コンフリクト回避: 各チームの変更対象ファイルは原則重複しない（重複箇所はREADMEに明記）

## 変更対象ファイルのオーナーシップ

| ファイル | オーナー |
|----------|----------|
| `app/components/book_details_component.html.erb` | **Team B** (TwitterShare) → **Team C** (LikeButton) |
| `app/views/users/show.html.erb` | **Team D** |
| `app/views/relationships/*.turbo_stream.erb` | **Team C** |
| `app/views/likes/*.turbo_stream.erb` | **Team C** |
| `app/controllers/*.rb` | **Team E** |

`book_details_component.html.erb` はTeam BとTeam Cが両方変更するため、Team B → Team Cの順で作業すること。

## Claude Code スキル

チーム開発用のスキル（slash commands）が `.claude/commands/` に定義されている:

| コマンド | 説明 | 使い方 |
|----------|------|--------|
| `/team` | チームタスクを実行 | `/team c` でTeam Cのタスクを実行 |
| `/new-component` | 新規ViewComponent作成 | `/new-component LikeButtonComponent book:Book` |
| `/verify` | テスト+型チェック実行 | `/verify` で全テスト+srb tc |
| `/status` | リファクタリング進捗確認 | `/status` で全チームの完了状況を確認 |

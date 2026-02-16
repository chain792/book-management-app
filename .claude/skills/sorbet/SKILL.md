---
name: sorbet
description: Sorbet型定義のルールとパターン。Sorbetの型、sig、typed level、コントローラやコンポーネントの型付けに関する作業時に自動参照。
user-invocable: false
---

# Sorbet 型定義ルール

## typed level

| 対象 | level | sig |
|------|-------|-----|
| コンポーネント / ヘルパー | `# typed: strict` | 全メソッド |
| コントローラ | `# typed: true` | privateメソッドのみ（publicアクションにsig不要） |
| モデル | `# typed: true` | カスタムメソッド |

## コントローラの Getter パターン

ivar に型を伝えるため、リソース取得を private メソッドに切り出す:

```ruby
def edit
  @book = current_book
end

private

sig { returns(Book) }
def current_book
  current_user.books.find(params[:id])
end
```

## ストロングパラメータ

```ruby
sig { returns(ActionController::Parameters) }
def book_params
  params.require(:book).permit(:title, :body)
end
```

## publicアクションにsigを付けない

```ruby
# Good
def index
  @books = Book.all
end

# Bad（情報量ゼロのノイズ）
sig { void }
def index
  @books = Book.all
end
```

## associations の非nil shim

`belongs_to` で NOT NULL + presence: true の関連は `sorbet/rbi/shims/models/` で非nil化:

```ruby
# sorbet/rbi/shims/models/book.rbi
class Book
  sig { returns(::User) }
  def user; end
end
```

## コマンド

- 型チェック: `docker compose exec app bundle exec srb tc`
- RBI更新: `docker compose exec app bin/tapioca dsl`

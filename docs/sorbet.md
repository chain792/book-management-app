# Sorbet 導入と型定義ルール

このプロジェクトでは、Ruby の静的型チェックツールである [Sorbet](https://sorbet.org/) を導入しています。
コードの堅牢性と開発効率を両立するため、以下のルールに従って型定義を行っています。

## 基本方針
- **ハイブリッドな厳格度**: 基本的には `# typed: true` を使用し、ロジックが集中するモデルや共通モジュールなどは `# typed: strict` を目指します。
- **IDE連携**: Sorbet の LSP を活用し、開発中にリアルタイムで型エラーを検知することを推奨します。

## 共通ルール

### 1. ログインユーザーの扱い (`current_user!`)
認証が必要なアクションでは、`current_user`（nilの可能性がある）の代わりに `current_user!` を使用してください。
- `current_user!` は常に `User` 型（非nil）を返すため、`T.must` による型強制を減らすことができます。

```ruby
# Good
current_user!.books.build(book_params)

# Bad (T.must が必要になる)
T.must(current_user).books.build(book_params)
```

### 2. コントローラの Getter パターン
インスタンス変数（`@book` など）に正しい型を教えるため、リソース取得用の Getter メソッドを定義し、そこに `sig` を付与してください。

```ruby
def edit
  @book = current_book # @book が正しく Book 型として認識される
end

private

sig { returns(Book) }
def current_book
  current_user!.books.find(params[:id])
end
```

### 3. ストロングパラメータの型定義
`params` メソッドに `ActionController::Parameters` の戻り値を明示することで、`build(params)` などの戻り値が Sorbet によって正しく推論されるようになります。

```ruby
sig { returns(ActionController::Parameters) }
def book_params
  params.require(:book).permit(:title, :body)
end
```

### 4. アクションの `sig` 省略
コントローラのパブリックアクション（`index`, `create` など）において、戻り値が自明（`void`）な場合は、コードの冗長性を避けるために `sig { void }` を省略しても構いません。
※ ただし、プライベートメソッドや値を返すメソッドには必ず `sig` を記述してください。

### 5. 関連 (Associations) の推論改善と強制非nil化
Rails の `belongs_to` 関連は、DB 側で `null: false` 制約がありモデルで `presence: true` バリデーションがあっても、Sorbet (Tapioca) はデフォルトで「nil の可能性がある」(`T.nilable`) と推論します。

このため、本来 nil にならないはずの関連呼び出しで `T.must` が必要になり、コードが冗長になります。これを解決するため、`sorbet/rbi/shims/associations.rbi` で関連メソッドの戻り値を「非nil」として手動で上書きしています。

**導入理由:**
- `belongs_to` 関連が必ず存在することを保証し、`T.must` を削減するため。
- Rails の慣習的なコード（`@book.user.name` など）を型エラーなしで書けるようにするため。

**Shim の構成:**
`sorbet/rbi/shims/models/` 配下に、モデルごとにファイルを分けて定義しています。
例: `sorbet/rbi/shims/models/book.rbi`
```ruby
# Book モデルの関連を非 nil 化
class Book
  sig { returns(::User) }
  def user; end

  sig { returns(::Category) }
  def category; end
end
```

### 6. 関連メソッドの戻り値エラー
Rails の関連メソッド（`build`, `new`）が配列を返す（`T::Array`）と誤認される場合は、前述の「パラメータメソッドへの型定義」を優先して試してください。

## 便利なコマンド
- 型チェックの実行: `bundle exec srb tc`
- RBI の更新: `bin/tapioca dsl` (モデルやルートの変更時)

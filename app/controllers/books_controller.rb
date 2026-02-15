# typed: true

class BooksController < ApplicationController
  extend T::Sig

  allow_unauthenticated_access only: %i[index show]

  sig { void }
  def index
    @books = Book.all.includes(:authors, :user, :category).order(created_at: :desc)
  end

  sig { void }
  def new
    @book = Book.new
    @volume_info = params[:volumeInfo]
    set_category
  end

  sig { void }
  def create
    @book = current_user!.books.build(book_params)
    if @book.save_with_author(authors_params[:authors])
      redirect_to books_path, notice: "レビューを作成しました"
    else
      set_category
      set_volume_info
      flash.now[:alert] = "レビューを作成できませんでした"
      render "new", status: :unprocessable_content
    end
  end

  sig { void }
  def show
    @book = Book.find(params[:id])
    @comment = Comment.new
    @comments = @book.comments.includes(:user).order(:id)
  end

  sig { void }
  def edit
    @book = current_book
    set_category
  end

  sig { void }
  def update
    @book = current_book
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "レビューを更新しました", status: :see_other
    else
      set_category
      flash.now[:alert] = "レビューを更新できませんでした"
      render "edit", status: :unprocessable_content
    end
  end

  sig { void }
  def destroy
    @book = current_book
    @book.destroy!
    redirect_to books_path, notice: "レビューを削除しました", status: :see_other
  end

  sig { void }
  def search
    if params[:search].nil?
      nil
    elsif params[:search].blank?
      flash.now[:alert] = "検索キーワードが入力されていません"
      nil
    else
      url = "https://www.googleapis.com/books/v1/volumes"
      text = T.must(params[:search])
      connection = Faraday.new
      res = connection.get(url, q: text, langRestrict: "ja", maxResults: 30, key: ENV["GOOGLE_API_KEY"])
      @google_books = JSON.parse(res.body)
    end
  end

  private

  sig { returns(ActionController::Parameters) }
  def book_params
    case action_name
    when "create"
      params.require(:book).permit(:title, :body, :book_image_remote_url, :info_link, :published_date).merge(category_id: category_id)
    when "update"
      params.require(:book).permit(:body)
    else
      ActionController::Parameters.new
    end
  end

  sig { returns(T.any(Integer, String)) }
  def category_id
    category_params = params.require(:book).permit(:parent_category, :child_category)
    category_params[:child_category].present? ? category_params[:child_category] : category_params[:parent_category]
  end

  sig { returns(ActionController::Parameters) }
  def authors_params
    params.require(:book).permit(authors: [])
  end

  sig { returns(Book) }
  def current_book
    current_user!.books.find(params[:id])
  end

  sig { void }
  def set_volume_info
    @volume_info = {}
    @volume_info[:title] = params[:book][:title]
    @volume_info[:authors] = params[:book][:authors]
    @volume_info[:bookImage] = params[:book][:book_image_remote_url]
    @volume_info[:infoLink] = params[:book][:info_link]
    @volume_info[:publishedDate] = params[:book][:published_date]
  end

  sig { void }
  def set_category
    @categories = Category.pluck(:id, :name, :ancestry)
    # 親カテゴリーを取得
    @parent_category = @categories.filter_map { |category| [ category[1], category[0] ] if category[2].nil? }
  end
end

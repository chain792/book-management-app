class BooksController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_book, only: %i[edit update destroy]

  def index
    @books = Book.all.includes(:authors, :user, :category).order(created_at: :desc)
  end

  def new
    @book = Book.new
    @volume_info = params[:volumeInfo]
    set_category
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save_with_author(authors_params[:authors])
      redirect_to books_path, success: t('defaults.message.created', item: t('defaults.review'))
    else
      set_category
      set_volume_info
      flash.now[:danger] = t('defaults.message.not_created', item: t('defaults.review'))
      render 'new'
    end
  end

  def show
    @book = Book.find(params[:id])
    @comment = Comment.new
    @comments = @book.comments.includes(:user)
  end

  def edit
    set_category
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), success: t('defaults.message.updated', item: t('defaults.review'))
    else
      set_category
      flash.now[:danger] = t('defaults.message.not_updated', item: t('defaults.review'))
      render 'edit'
    end
  end

  def destroy
    @book.destroy!
    redirect_to books_path, success: t('defaults.message.deleted', item: t('defaults.review'))
  end

  def search 
    if params[:search].nil?
      return
    elsif params[:search].blank?
      flash.now[:danger] = '検索キーワードが入力されていません'
      return
    else
      url = "https://www.googleapis.com/books/v1/volumes"
      text = params[:search]
      res = Faraday.get(url, q: text, langRestrict: 'ja', maxResults: 30, key: ENV['GOOGLE_API_KEY'])
      @google_books = JSON.parse(res.body)
    end
  end

  private

  def book_params
    case action_name
    when 'create'
      params.require(:book).permit(:title, :body, :remote_book_image_url, :info_link, :published_date).merge(category_id: category_id)
    when 'update'
      params.require(:book).permit(:body)
    end
  end

  def category_id
    category_params = params.require(:book).permit(:parent_category, :child_category)
    category_params[:child_category].present? ? category_params[:child_category] : category_params[:parent_category]
  end

  def authors_params
    params.require(:book).permit(authors: [])
  end

  def set_book
    @book = current_user.books.find(params[:id])
  end

  def set_volume_info
    @volume_info = {}
    @volume_info[:title] = params[:book][:title]
    @volume_info[:authors] = params[:book][:authors]
    @volume_info[:bookImage] = params[:book][:remote_book_image_url]
    @volume_info[:infoLink] = params[:book][:info_link]
    @volume_info[:publishedDate] = params[:book][:published_date]
  end

  def set_category
    categories = Category.pluck(:id, :name, :ancestry)
    gon.categories = categories
    # 親カテゴリーを取得
    @parent_category = categories.filter_map { |category| [category[1], category[0]] if category[2].nil? }
  end
end

class CategoriesController < ApplicationController
  skip_before_action :require_login, only: %i[show]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    category_ids = @category.subtree_ids
    @books = Book.where(category_id: category_ids).includes(:authors, :user, :category).order(created_at: :desc)
  end
end

# typed: true
class CategoriesController < ApplicationController
  extend T::Sig

  allow_unauthenticated_access only: %i[show]

  sig { void }
  def index
    @categories = Category.all
  end

  sig { void }
  def show
    @category = Category.find(params[:id])
    category_ids = @category.subtree_ids
    @books = Book.where(category_id: category_ids).includes(:authors, :user, :category).order(created_at: :desc)
  end
end

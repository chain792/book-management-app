class LikesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    current_user.like(@book)

    respond_to do |format|
      format.html { redirect_to book_path(@book), status: :see_other }
      format.turbo_stream
    end
  end

  def destroy
    @book = current_user.likes.find(params[:id]).book
    current_user.unlike(@book)

    respond_to do |format|
      format.html { redirect_to book_path(@book), status: :see_other }
      format.turbo_stream
    end
  end
end

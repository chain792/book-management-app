class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    
    if @comment.save
      redirect_to book_path(@comment.book)
    else
      @book = @comment.book
      @comments = @book.comments.includes(:user).order(:id)
      render "books/show", status: :unprocessable_content
    end
  end

  def update
    if @comment.update(comment_update_params)
      redirect_to book_path(@comment.book), status: :see_other
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to book_path(@comment.book) }
      end
    end
  end

  def destroy
    @comment.destroy!
    redirect_to book_path(@comment.book), status: :see_other
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(book_id: params[:book_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body)
  end
end

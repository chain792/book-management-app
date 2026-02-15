# typed: true

class CommentsController < ApplicationController
  extend T::Sig

  sig { void }
  def create
    @comment = current_user!.comments.build(comment_params)

    if @comment.save
      redirect_to book_path(@comment.book)
    else
      @book = @comment.book
      @comments = @book.comments.includes(:user).order(:id)
      render "books/show", status: :unprocessable_content
    end
  end

  sig { void }
  def update
    @comment = current_comment
    if @comment.update(comment_update_params)
      redirect_to book_path(@comment.book), status: :see_other
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to book_path(@comment.book) }
      end
    end
  end

  sig { void }
  def destroy
    @comment = current_comment
    @comment.destroy!
    redirect_to book_path(@comment.book), status: :see_other
  end

  private

  sig { returns(Comment) }
  def current_comment
    current_user!.comments.find(params[:id])
  end

  sig { returns(ActionController::Parameters) }
  def comment_params
    params.require(:comment).permit(:body).merge(book_id: params[:book_id])
  end

  sig { returns(ActionController::Parameters) }
  def comment_update_params
    params.require(:comment).permit(:body)
  end
end

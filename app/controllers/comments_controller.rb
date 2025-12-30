class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  def update
    if @comment.update(comment_update_params)
      render json: { comment: @comment }, status: :ok
    else
      render json: { comment: @comment, errors: { messages: @comment.errors.full_messages } }, status: :bad_request
    end
  end

  def destroy
    @comment.destroy!
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

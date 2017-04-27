class CommentsController < ApplicationController
  after_action :verify_authorized, except: [:index]

  def create
    @comment = @commentable.comments.new comment_params
    authorize @comment
    @comment.user = current_user
    @comment.save
    redirect_to @commentable, notice: "Your comment was successfully posted."
  end

  private
    def comment_params
      params.require(:comment).permit(:text)
    end
end
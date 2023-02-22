class CommentsController < ApplicationController
    before_action :set_current_user
    def create
        # create a new comment for the post from the current_user
        user = User.find(params[:user_id])
        @comment = user.comments.new(comment_params)
        @comment.group_id = params[:group_id]
        if @comment.save
          redirect_to group_path(params[:group_id]), notice: 'Comment was successfully created.'
        else
          flash[:notice] = @comment.errors.full_messages.to_sentence
        end
    end
      
  
    private
  
    def comment_params 
      params.require(:comment).permit(:content)
    end
  
    def set_current_user
      @current_user = current_user
    end
  end
  
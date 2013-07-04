class HomeController < ApplicationController

	# GET /home/index
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /home/ideas.json
  def ideas
    @ideas = Idea.all_and_current_user_voted(session[:user_id])

    respond_to do |format|
      format.json { render json: @ideas }
    end
  end

  # GET /home/comments.json
  def comments
  	@comments = Comment.where(idea_id: params[:id]).joins(:user).select('comments.*, image as user_image').order('comments.id')

  	respond_to do |format|
  		format.json { render json: @comments }
    end
  end

  # POST /home/add_comment.json
  def add_comment
  	@comment = Comment.new
  	@comment.description = params[:description]
  	@comment.user = User.find(session[:user_id])
  	@comment.idea = Idea.find(params[:idea_id])
  	@comment.save!

  	respond_to do |format|
  		if @comment.save
        # really bad, find better way to do it!!!
        @comment_response = Comment.where(id: @comment.id).joins(:user).select('comments.*, image as user_image').first

  			format.json { render json: @comment_response, status: :created }
  		else
  			format.json { render json: @comment.errors, status: :unprocessable_entity }
  		end
  	end
  end

  # DELETE /home/remove_comment/1.json
  def remove_comment
    @comment = Comment.find_by_id_and_user_id(params[:id], session[:user_id])
    
    if @comment
      @comment.destroy

      respond_to do |format|
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.json { head :not_found }
      end
    end          
  end
end

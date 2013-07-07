class HomeController < ApplicationController
  respond_to :json

	# GET /home/index
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /home/ideas.json
  def ideas
    @ideas = Idea.all_and_current_user_voted(session[:user_id])

    respond_with(@ideas)
  end

  # GET /home/comments.json
  def comments
  	@comments = Comment.where(idea_id: params[:id]).joins(:user).select('comments.*, image as user_image').order('comments.id')

  	respond_with(@comments)
  end

  # POST /home/add_comment.json
  def add_comment
  	@comment = Comment.create({ description: params[:description], user_id: session[:user_id], idea_id: params[:idea_id] })

  	respond_to do |format|
  		if @comment.persisted?
  			format.json { render json: Comment.get_comment_and_its_user_image(@comment.id), status: :created }
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

      respond_with(:head => :no_content)
    else
      respond_with(:head => :not_found)  
    end          
  end
end
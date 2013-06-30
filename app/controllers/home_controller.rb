class HomeController < ApplicationController

	# GET /home/index
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /home/ideas.json
  def ideas
    @ideas = Idea.all

    respond_to do |format|
      format.json { render json: @ideas }
    end
  end

  # GET /home/comments.json
  def comments
  	@comments = Comment.all

  	respond_to do |format|
  		format.json { render json: @comments }
		end
  end

  # POST /home/add_comment.json
  def add_comment
  	@comment = Comment.new(params[:comment])

  	respond_to do |format|
  		if @comment.save
  			format.json { render json: @comment, status: :created, location: @idea }
  		else
  			format.json { render json: @comment.errors, status: :unprocessable_entity }
  		end
  	end
  end
end

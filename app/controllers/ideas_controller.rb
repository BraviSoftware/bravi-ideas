class IdeasController < ApplicationController
  before_filter :check_permissions

  # GET /ideas
  # GET /ideas.json
  def index
    @ideas = Idea.where(user_id: session[:user_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ideas }
    end
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
    @idea = Idea.find_by_id_and_user_id(params[:id], session[:user_id])

    if @idea.blank?
      redirect_to ideas_url
    else
      respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @idea }
      end
    end
  end

  # GET /ideas/new
  # GET /ideas/new.json
  def new
    @idea = Idea.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @idea }
    end
  end

  # GET /ideas/1/edit
  def edit
    @idea = Idea.find(params[:id])
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = Idea.new(params[:idea])
    @idea.user_id = session[:user_id]

    respond_to do |format|
      if @idea.save
        format.html { redirect_to @idea, notice: 'Idea was successfully created.' }
        format.json { render json: @idea, status: :created, location: @idea }
      else
        format.html { render action: "new" }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ideas/1
  # PUT /ideas/1.json
  def update
    @idea = Idea.find_by_id_and_user_id(params[:id], session[:user_id])

    respond_to do |format|
      if @idea.update_attributes(params[:idea])
        format.html { redirect_to @idea, notice: 'Idea was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy

    respond_to do |format|
      format.html { redirect_to ideas_url }
      format.json { head :no_content }
    end
  end



  # PUT /ideas/1/like
  def like
    @previousVote = Vote.find_by_idea_id_and_user_id(params[:id], session[:user_id])
    if @previousVote.blank?
      @idea = Idea.find(params[:id])
      @idea.like()

      @vote = Vote.new like: true, user_id: session[:user_id], idea_id: params[:id]
    end

    respond_to do |format|
      if @previousVote.present?
        format.json { render json: @previousVote, status: :bad_request }
      elsif @idea.update_attribute :positive, @idea.positive && @vote.save
        format.json { head :no_content }
      else
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ideas/1/unlike
  def unlike
    @previousVote = Vote.find_by_idea_id_and_user_id(params[:id], session[:user_id])
    if @previousVote.blank?
      @idea = Idea.find(params[:id])
      @idea.unlike()

      @vote = Vote.new like: false, user_id: session[:user_id], idea_id: params[:id]
    end

    respond_to do |format|
      if @previousVote.present?
        format.json { render json: @previousVote, status: :bad_request }
      elsif @idea.update_attribute :negative, @idea.negative && @vote.save
        format.json { head :no_content }
      else
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  rescue_from SecurityError do |exception|
    flash[:error] = exception.message
    redirect_to current_user || root_path
  end

  def check_permissions
    unless current_user
      raise SecurityError, "You have no permissions to access this page"
    end
  end
end

class CommentsController < ApplicationController
  before_filter :load_commentable, except: [:new, :destroy]
  before_filter :load_reply_commentable, only: [:new, :destroy]
  before_action :load_product

  def new
    @comment = @commentable.comments.new(parent_id: params[:parent_id])
    render layout: false
  end

  def create
    if signed_in?
      @comment = @commentable.comments.new(params[:comment])
      @comment.user_id = current_user.id
      if @comment.save
        Activity.create(timestamp: Time.now, user_id: current_user.id, activity_type: :comment, resource_type: @commentable.classify, resource_id: @commentable.id)
        render partial: '/comments/comment', locals: {comment: @comment, product: @product}, notice: "Comment created.", :name => "tab[#{params[:tab]}]" 
      end
    else 
      respond_to do |format|
        format.html { redirect_to signup_path, notice: 'Please Sign In or Sign Up to Comment.' }
        format.json { render action: 'show', status: :created, location: @comment }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment = @commentable.comments.new(params[:comment])
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @commentable, notice: 'Comment was successfully updated.', :name => "tab[#{params[:tab]}]" }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    puts "$$\n" * 50
    @comment = Comment.find(params[:id])
    if signed_in? and (current_user.id == @comment.user.id or is_admin?)
      @comment.body = 'Deleted'
      @comment.deleted = true
      @comment.save
      render json: @comment.to_json 
    else
      flash notice: 'You are not allowed to delete that'
      redirect_to signup_path, notice: 'Please Sign In or Sign Up to Comment.' 
    end
  end

  def vote
    if signed_in? 
      @comment = Comment.find(params[:comment_id])
      @comment.vote current_user, YAML.load(params[:up])
      Activity.create(timestamp: Time.now, user_id: current_user.id, activity_type: :like, resource_type: @commentable.classify, resource_id: @commentable.id)
      render json: @comment.to_json 
    else
      redirect_to @product, notice: 'Please sign in before weighing in.' 
    end
  end

  private
    def load_commentable
      thepath = request.path.split('/')
      resource = thepath[-3]
      id = thepath[-2]
      @commentable = resource.singularize.classify.constantize.find(id)
    end

    def load_reply_commentable
      path = request.path.split('/')
      resource = path[1]
      id = path[2]
      @commentable = resource.singularize.classify.constantize.find(id)
    end

    def load_product
      @product = Product.find(params[:product_id])
    end
end

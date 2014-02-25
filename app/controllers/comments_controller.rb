class CommentsController < ApplicationController
 
  before_filter :load_commentable

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all.order('rating DESC')
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @user = User.find(@comment.user_id)
    @product = Product.find(params[:id])
    @comments = Comment.find(:product_id => @product.id)
  end

  # GET /comments/new
  def new
    @comment = @commentable.comments.new
  end

  # GET /comments/1/edit
  def edit
    
  end

  # POST /comments
  # POST /comments.json
  def create
    if signed_in?
      @comment = @commentable.comments.new(params[:comment])
      #@product = Product.find(params[:product_id]) || Product.find(params[:id])
      @comment.user_id = current_user.id
      @comment.user = current_user
      @user = current_user
      respond_to do |format|
        if @comment.save
          Activity.create(timestamp: @comment.created_at, user_id: @user.id, activity_type: :comment, resource_type: @commentable.class.name, resource_id: @commentable.id)
          format.html { redirect_to request.referer, notice: "Comment created." }
          format.json { render action: 'show', status: :created, location: @comment }
          #format.js { render :js => 'function () {
          # $(\'#product-tabs a[href="#product-comments"]\').tab(\'show\')
          # }' }
        else
          format.html { render action: 'new' }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
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
        format.html { redirect_to @commentable, notice: 'Comment was successfully updated.' }
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
    @comment = @commentable.comments.new(params[:comment])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end

  def upvote
    @product = Product.find(params[:product_id])
    if signed_in? 
      @comment = Comment.find(params[:comment_id])
      if !@comment.upvotes.nil? 
        ups = @comment.upvotes.where(:user_id => current_user.id).delete_all.to_i
        downs = @comment.downvotes.where(:user_id => current_user.id).delete_all.to_i
        @comment.upvotes.build(:user_id => current_user.id, :up => true, :product => @product.id)
        @comment.rating = @comment.upvotes.size - @comment.downvotes.size
        @comment.save
        respond_to do |format|
          format.html { redirect_to @product, notice: 'Comment was successfully updated.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to @product, notice: 'You can only give your support once for each comment.' }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @product, notice: 'Please sign in before weighing in.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def downvote
    @product = Product.find(params[:product_id])
    if signed_in? 
      @comment = Comment.find(params[:comment_id])
      if !@comment.downvotes.nil?
        ups = @comment.upvotes.where(:user_id => current_user.id).delete_all.to_i
        downs = @comment.downvotes.where(:user_id => current_user.id).delete_all.to_i
        @comment.downvotes.build(:user_id => current_user.id, :up => false, :product => @product.id)
        @comment.rating =  @comment.upvotes.size - @comment.downvotes.size
        @comment.save
        respond_to do |format|
          format.html { redirect_to @product, notice: 'Comment was successfully updated.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to @product, notice: 'You can only give your support once for each comment.' }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @product, notice: 'Please sign in before weighing in.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = @commentable.find(params[:id])
      if !params[:product_id].nil?
        @product = Product.find(params[:product_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:title, :comment_id, :product_id, :user_id, :user, :body, :commentable_id)
    end

    def load_commentable
      resource, id = request.path.split('/')[1, 2]
      thepath = request.path.split('/')
      resource = thepath[-3]
      id = thepath[-2]
      puts resource + ' is the resource'
      puts id + ' is the id '
      @commentable = resource.singularize.classify.constantize.find(id)
    end
end

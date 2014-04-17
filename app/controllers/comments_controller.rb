class CommentsController < ApplicationController
 
  before_filter :load_commentable, except: [:new]
  before_filter :load_reply_commentable, only: :new

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
    @comment = @commentable.comments.new(parent_id: params[:parent_id])
    render layout: false

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
      product = Product.find(params[:product_id])
      Activity.create(timestamp: Time.now, user_id: current_user.id, activity_type: :comment, resource_type: @commentable.class.name, resource_id: @commentable.id)
      respond_to do |format|
        if @comment.save
          Activity.create(timestamp: @comment.created_at, user_id: @user.id, activity_type: :comment, resource_type: @commentable.class.name, resource_id: @commentable.id).save
          
          if @comment.commentable_type == "Bounty"
            format.html { render partial: '/comments/comment',locals: {comment: @comment, product: product || @comment.product, bounty: Bounty.find(@comment.commentable_id) }, notice: "Comment created.", :name => "tab[#{params[:tab]}]" }
          else 
            format.html { render partial: '/comments/comment', locals: {comment: @comment, product: product || @comment.product }, notice: "Comment created.", :name => "tab[#{params[:tab]}]" }
          end
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
    @comment = Comment.find(params[:comment_id])
    if signed_in? and (current_user.id == @comment.user.id or is_admin?)
      @comment.body = 'Deleted'
      @comment.deleted = true
      @comment.save
      redirect_to @comment.product  
    else
      flash notice: 'You are not allowed to delete that'
    end
  end

  def vote
    @product = Product.find(params[:product_id])
    if signed_in? 
      @comment = Comment.find(params[:comment_id])
      @comment.likes.where(:user_id => current_user.id).delete_all
      @comment.likes.create(:user_id => current_user.id, :up => YAML.load(params[:up]), :product_id => @product.id)
      @comment.rating = @comment.upvotes.size - @comment.downvotes.size
      @comment.save!
      respond_to do |format|
        format.json { render json: @comment.to_json }
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

    def load_reply_commentable
      path = request.path.split('/')
      resource = path[1]
      id = path[2]
      puts resource + ' is the resource'
      puts id + ' is the id '
      @commentable = resource.singularize.classify.constantize.find(id)
    end
end

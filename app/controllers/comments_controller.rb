class CommentsController < ApplicationController
  before_filter :load_commentable, except: [:new]
  before_filter :load_reply_commentable, only: :new
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
        render partial: '/comments/comment', locals: {comment: @comment, product: @product}, notice: "Comment created.", :name => "tab[#{params[:tab]}]" 
      end
    else 
      redirect_to signup_path, notice: 'Please Sign In or Sign Up to Comment.' 
    end
  end

  def vote
    if signed_in? 
      @comment = Comment.find(params[:comment_id])
      @comment.vote current_user, YAML.load(params[:up])
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

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :initial_uploads, :active_switch, :upload_picture, :grant_access]


  def index
    @products = Product.all
  end

  def show  # what if there is no propic id?
    @user_pic = ImageAsset.find_product_user_pic @product if !@product.user.pictures
    @feature_groups = @product.feature_groups
    @comment = @product.comments.new
    @likers = @product.followers
  end

  def new
    if signed_in?
      @product = Product.new
      @product.pictures.build
      @product.user_id = current_user.id
    else
      redirect_to signup_path, notice: 'Please sign up before creating anything!'
    end
  end

  def edit
    @product.pictures.build
  end

  def create
    if signed_in?
      @product = Product.new product_params
      @product.user_id = current_user.id 
      if current_user.creator and @product.save
        Activity.create(timestamp: Time.now, user_id: current_user.id, activity_type: :create, resource_type: :product, resource_id: @product.id)
        redirect_to product_initial_uploads_path(@product), notice: 'Product was successfully created.'
      else
        flash[:warning] = "You don't yet have permission to create drives, try contributing to a few first!" 
        redirect_to request.referer
      end
    else
      flash[:warning] = "You must be signed in to create a drive!"
      redirect_to request.referer
    end
  end

  def update
    @product.product_pic = product_pic = @product.pictures.last
    if @product.update_attributes product_params 
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url 
  end

  def upload_picture
    @image_asset = ImageAsset.new(params[:upload])
    if @product.user.id == current_user.id
      @product.pictures.build(params[:upload])
      render json: [@image_asset.to_jq_upload], content_type: 'text/html', layout: false if @product.save
    end
  end

  def love
    @product = Product.find(params[:product_id])    
    @tab = 'product-comments'
    if signed_in?
      if !@product.likes.exists?(user_id: current_user.id)
        if @product.likes.create(user_id: current_user.id)
          Activity.create(timestamp: Time.now, user_id: current_user.id, activity_type: :like, resource_type: :product, resource_id: @product.id)
          redirect_to @product, notice: 'Product was successfully updated.' 
        else
          redirect_to @product, notice: 'Not allowed to love'
        end
      else
        redirect_to @product, notice: 'User has already liked this!'
      end
    else
      redirect_to @product, notice: 'Please sign in before weighing in!' 
    end
  end

  def active_switch
    if signed_in? && @product.user.id == current_user.id
      @product.active = @product.active ? false : true
      @product.save
    end
    redirect_to @product
  end

  def initial_uploads
  end

  def grant_access
    if @product.password == params[:product][:pwd]
      if signed_in?
        if !@product.parsed_list.include?(current_user.id)
          @product.access_list += ",#{current_user.id}"
          @product.save
        end
        redirect_to @product
      else
        flash[:notice] = "That drive was private, so please signup first"
        redirect_to signup_path
      end
    else
      flash[:notice] = "You should have received an access password from #{@product.user.name} " +
       "to access this."
       redirect_to request.referer
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = params[:id] ? Product.find(params[:id]) : Product.find(params[:product_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :hidden, :pwd, :rating, :feature_groups, :features, :image_asset, :link, :description, :tab, :id, :pictures, :image_asset, :product_pic, pictures_attributes: [:attachment_attributes, :attachment, :id, :pictures_attributes],
                                      lovers: [:product_id, :user_id])
    end

    # product rating = (10 * product_likes) + sum(feature_likes for each feature)
    def update_rating
      @product.rating = @product.likes.size * 10
      @product.feature_groups.where(singles: false).each do |fg|
        fg.features.each do |f|
          up_rating = f.likes.where(up: true).size
          down_rating = f.likes.where(up: false).size
          @product.rating += up_rating - down_rating
        end
      end
      @product.feature_groups.where(singles: true).each do |singles|
        singles.features.each do |f|
          @product.rating += f.likes.where(up: true).size - f.likes.where(up: false).size
        end
      end
      # here we should somehow incorporate comments on the product into the rating
      @product.save
    end

    def loved?
      if !current_user.nil?
        @product = Product.find(params[:product_id]) || Product.find(params[:id])
        if @product.lovers.contains(current_user)
          true
        end
        false
      end
      true
    end
end


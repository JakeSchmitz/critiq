class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    @top_products = @products.order("rating desc")
    @user = current_user
  end

  # GET /products/1
  # GET /products/1.json
  def show
    set_product
    update_rating
    @tab = 'product-comments'
    @product ||= Product.find( :id => params[:product_id])
    if !@product.user.pictures.empty?
      @user_pic = ImageAsset.find(@product.user.propic_id || @product.user.pictures.last)
    end
    @feature_groups = @product.feature_groups
    @comparison_features = @feature_groups.where(singles: false)
    @single_features = @feature_groups.where(singles: true).first
    @comments = @product.comments.order('rating DESC')
    @comment = @product.comments.new
    @likers = Array.new
    @top_pics = @product.pictures.where.not(:attachment_file_size => nil).order('created_at DESC').limit(5)
    @product.likes.first(100).each do |like|
      @likers << User.find(like.user_id)
    end
  end

  # GET /products/new
  def new
    if signed_in?
      @product = Product.new
      @product.pictures.build
      @product.user_id = current_user.id
    else
      redirect_to signup_path, :notice => 'Please sign up before creating anything!'
    end
  end

  # GET /products/1/edit
  def edit
    set_product
    @product.pictures.build
  end

  # POST /products
  # POST /products.json
  def create
    if signed_in?
      @product = Product.new(product_params)
      @product.rating = 0
      @single_features = @product.feature_groups.build(:name => 'singletons', :description => 'lorem', :singles => true, :product_id => @product.id)
      @product.bounties.build(:question => "What can we do better?")
      @product.user_id = current_user.id 
      Activity.create(timestamp: Time.now, user_id: current_user.id, activity_type: :create, resource_type: :product, resource_id: @product.id)
      respond_to do |format|
        if @product.save
          format.html { redirect_to @product, notice: 'Product was successfully created.' }
          format.json { render action: 'show', status: :created, location: @product }
        else
          format.html { render action: 'new' }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to home
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    set_product
    respond_to do |format|
      update_rating
      @product.product_pic = product_pic = @product.pictures.last
      if @product.update_attributes(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def upload_picture
    @product = Product.find(params[:product_id]) || Product.find(params[:id])
    if @product.user.id == current_user.id
      puts "Uploading image " + params[:upload].to_s
      @product.pictures.build(params[:upload])
      @product.save
    end
    redirect_to @product
  end

  def love
    @product = Product.find(params[:product_id])
    update_rating
    @tab = 'product-comments'
    if signed_in?
      if !@product.likes.exists?(:user_id => current_user.id)
        respond_to do |format|
          if  @product.likes.create(:user_id => current_user.id)
            update_rating
            @product.save
            Activity.create(timestamp: Time.now, user_id: current_user.id, activity_type: :like, resource_type: :product, resource_id: @product.id)
            format.html { redirect_to @product, notice: 'Product was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { redirect_to @product, notice: 'Not allowed to love' }
            format.json { render json: @product.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to @product, notice: 'User has already liked this!' }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @product, notice: 'Please sign in before weighing in!' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def active_switch
    @product = Product.find(params[:product_id])
    if signed_in? and @product.user.id == current_user.id
      @product.active = @product.active ? false : true
      @product.save
    end
    redirect_to @product
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id]) || Product.find(params[:product_id])
      @creator = @product.user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :rating, :image, :description, :id, :pictures, :product_pic, pictures_attributes: [:attachment_attributes, :attachment, :id, :pictures_attributes], product_pic_attributes: [:attachment_attributes, :attachment, :id, :product_pic_attributes],
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


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
    @product ||= Product.find( :id => params[:product_id])
    @product.pictures.build
    @feature_groups = FeatureGroup.where(:product => @product)
    @comparison_features = @feature_groups.where.not(name: 'singletons', description: 'lorem')
    @single_features = @feature_groups.where(:name => 'singletons', :description => 'lorem').first
    if @single_features.nil?
      @single_features = FeatureGroup.create(:product_id => @product.id, :name => 'singletons', :description => 'lorem')
      @single_features.save
    end
    @comments = Comment.where(:product_id => @product.id).order('rating DESC')
    @product ||= Product.find(params[:id])
    @comment = Comment.new
    @likers = Array.new
    @product.likes.each do |like|
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
    @product.features.build
  end

  # POST /products
  # POST /products.json
  def create
    if signed_in?
      @product = Product.new(product_params)
      @product.rating = 0
      @product.feature_groups.build(:name => 'singletons', :description => 'lorem')
      @product.user_id = current_user.id 
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
      @product_pic = @product.pictures.last
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

  def love
    @product = Product.find(params[:product_id])
    update_rating
    if signed_in?
      if !@product.likes.exists?(:user_id => current_user.id)
        respond_to do |format|
          if  @product.likes.create(:user_id => current_user.id)
            update_rating
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id]) || Product.find(params[:product_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :rating, :image, :description, :id, :pictures, :product_pic, pictures_attributes: [:attachment_attributes, :attachment, :id, :pictures_attributes], product_pic_attributes: [:attachment_attributes, :attachment, :id, :product_pic_attributes],
                                      lovers: [:product_id, :user_id])
    end

    # product rating = (10 * product_likes) + sum(feature_likes for each feature)
    def update_rating
      @product.rating = @product.likes.length * 10
      @product.feature_groups.where.not(name: 'singletons', description: 'lorem').each do |fg|
        fg.features.each do |f|
          @product.rating = @product.rating + f.upvotes.length
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

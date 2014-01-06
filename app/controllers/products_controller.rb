class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    @user = current_user
  end

  # GET /products/1
  # GET /products/1.json
  def show
    set_product
    @features = Feature.where(:product_id => params[:product_id])
  end

  # GET /products/new
  def new
    @product = Product.new
    @product.pictures.build
    @product.user_id = current_user.id
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
      @pictures = @product.pictures.build
      @product_pic = @pictures
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
    if !current_user.nil? 
      @product = Product.find(params[:product_id])
      if !@product.lovers.includes(current_user)
        @product.lovers.build(current_user)
        if @product.save
          format.html { redirect_to @product, notice: 'Product was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { redirect_to @product }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
    redirect_to @product, nodice: 'Something fucked up'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :image, :description, :user_id, :pictures, :product_pic, pictures_attributes: [:attachment_attributes, :attachment, :id, :pictures_attributes], product_pic_attributes: [:attachment_attributes, :attachment, :id, :product_pic_attributes])
    end

    def loved?
      if !current_user.nil?
        @product = Product.find(params[:product_id])
        if @product.lovers.contains(current_user)
          true
        end
        false
      end
      true
    end

end

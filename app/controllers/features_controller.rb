class FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :edit, :update, :destroy]

  # GET /product/pid/features
  # GET /features.json
  def index
    @features = Feature.all
  end

  # GET /product/1/features/1
  # GET /features/1.json
  def show
    set_feature
    @product = Product.find(params[:product_id])
    @feature.pictures.build
  end

  # GET /product/pid/features/new
  def new
    @product = Product.find(params[:product_id])
    @feature_group = FeatureGroup.find(params[:feature_group_id])
    @feature = @feature_group.features.build
    @feature.pictures.build
  end

  # GET /features/1/edit
  def edit
    @product = Product.find(params[:product_id])
    @feature_group = FeatureGroup.find(params[:feature_group_id])
    @feature = Feature.find(params[:id])
    @feature.pictures.build
  end

  # POST /features
  # POST /features.json
  def create
    @product = Product.find(params[:product_id])
    @feature_group = FeatureGroup.find(params[:feature_group_id])
    @feature = Feature.new(feature_params)
    @feature.product_id = @product.id
    @feature.feature_group_id = @feature_group.id
    respond_to do |format|
      if @feature.save
        Activity.create(timestamp: Time.now, user_id: current_user.id, activity_type: :create, resource_type: :feature, resource_id: @feature.id)
        format.html { redirect_to product_path(@product), notice: 'Feature was successfully created.' }
        format.json { render action: 'show', status: :created, location: @feature }
      else
        format.html { render action: 'new' }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product/:product_id/features/1
  # PATCH/PUT /features/1.json
  def update
    set_feature
    @feature.pictures.build
    respond_to do |format|
      if @feature.update_attributes(feature_params)
        format.html { redirect_to @product, notice: 'Feature was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    @product = Product.find(params[:product_id])
    @feature.destroy
    respond_to do |format|
      format.html { redirect_to @product }
      format.json { head :no_content }
    end
  end

  def upvote
    @product = Product.find(params[:product_id])
    @tab = 'product-features'
    if signed_in? 
      @feature = Feature.find(params[:feature_id])
      if !@feature.upvotes.nil? and !@feature.upvotes.exists?(:user_id => current_user.id)
        @feature.upvotes.build(:user_id => current_user.id)
        @product.rating += 1
        respond_to do |format|
          if @feature.save and @product.save
            Activity.create(timestamp: Time.now, user_id: current_user.id, activity_type: :like, resource_type: :feature, resource_id: @feature.id)
            format.html { redirect_to product_path(@product, anchor: 'product-features'), notice: 'Feature was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { render action: 'upvote' }
            format.json { render json: @feature.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to @product, notice: 'You can only give your support once for each feature.' }
          format.json { render json: @feature.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @product, notice: 'Please sign in before weighing in.' }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  def downvote
    if signed_in?
      @feature = Feature.find(params[:feature_id])
      @product = Product.find(params[:product_id])
      @feature.downvotes.build(:user_id => current_user.id)
      @product -= 1
      respond_to do |format|
        if @feature.save and @product.save
          format.html { redirect_to @product, notice: 'Feature was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'upvote' }
          format.json { render json: @feature.errors, status: :unprocessable_entity }
        end
      end
    else 
      respond_to do |format|
        format.html { redirect_to @product, notice: 'Please sign in before weighing in.' }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = Feature.find(params[:id])
      @product = Product.find(params[:product_id])
      @feature_group = FeatureGroup.find(params[:feature_group_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_params
      params.require(:feature).permit(:id, :product_id, :feature_id, :name, :description, :upvotes, :downvotes, :pictures, pictures_attributes: [:attachment_attributes, :attachment, :id, :pictures_attributes] )
    end
end

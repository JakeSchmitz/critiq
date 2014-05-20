class FeatureGroupsController < ApplicationController
  before_action :set_feature_group, only: [:show, :edit, :update, :destroy]

  def index
    @feature_groups = FeatureGroup.all
  end

  def show
  end

  def new
    @feature_group = FeatureGroup.new
    @product = Product.find(params[:product_id])
  end

  def edit
  end

  def create
    @feature_group = FeatureGroup.new(feature_group_params)
    @product = Product.find(params[:product_id])
    @feature_group.product_id = @product.id
    if @feature_group.save
      redirect_to product_path(@product, tab: 'product-features'), notice: 'Feature group was successfully created.' 
    else
      render action: 'new'
    end

  end

  def update
    respond_to do |format|
      if @feature_group.update(feature_group_params)
        format.html { redirect_to @product, notice: 'Feature group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feature_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feature_group.destroy
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.json { head :no_content }
    end
  end

  def vote 
    @feature_group = FeatureGroup.find(params[:feature_group_id])
    @feature = Feature.find(params[:feature_id])
    if @feature_group.features.includes(@feature) and signed_in?
      vote = @feature_group.vote_on @feature, current_user, params[:up].to_bool
      render json: vote
    end
  end

  helper_method :can_user_vote
  private

    def set_feature_group
      @feature_group = FeatureGroup.find(params[:id])
      @product = Product.find(params[:product_id])
    end

    def feature_group_params
      params.require(:feature_group).permit(:name, :description, :product_id, :up, :image_asset, features: [pictures: [:attachment, :image_asset, :attachment_attributes]] )
    end
end

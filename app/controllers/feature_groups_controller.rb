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
    set_feature_group
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
      format.html { redirect_to feature_groups_url }
      format.json { head :no_content }
    end
  end

  def vote
    @feature_group = FeatureGroup.find(params[:feature_group_id])
    @tab = 'product-features'
    previousLike = nil
    oldCount = 0
    @feature = Feature.find(params[:feature_id])
    if @feature_group.features.includes(@feature) and !current_user.nil?
      if !@feature_group.singles?
        @feature_group.features.each do |f|
          if !f.likes.where(user_id: current_user.id).empty?
            f.likes.where(user_id: current_user.id).delete_all
            # Necessary so clientside js can uncheck previous vote and update vote count
            previousLike = f
            oldCount = f.likes.where(up: true).size.to_i
          end
        end
      else
        @feature.likes.where(:user_id => current_user.id).delete_all
      end
      puts 'creating like for feature ' + @feature.name + ' with id = ' + @feature.id.to_s
      @feature.likes.create(:user_id => current_user.id, :up => YAML.load(params[:up]))
      @feature.save
      @feature_group.save
      Activity.create(timestamp: Time.now, user_id: current_user.id, activity_type: :like, resource_type: :feature, resource_id: @feature.id)
    end
    # Shitty workaround so that ajax liking works and response contains the old like count of 
    # whatever the current user used to likes
    if @feature_group.singles?
      # In the singleton case, oldCount is actually the updated likeage percentage
      oldCount = (@feature.percent_like*100).round(3)
      previousLike = @feature
    end
    formatted = previousLike.attributes 
    formatted['oldCount'] = oldCount
    formatted['newCount'] = @feature.likes.where(up: true).size.to_i
    respond_to do |format|
      format.json { render json: formatted.to_json }
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

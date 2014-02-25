class FeatureGroupsController < ApplicationController
  before_action :set_feature_group, only: [:show, :edit, :update, :destroy]

  # GET /feature_groups
  # GET /feature_groups.json
  def index
    @feature_groups = FeatureGroup.all
  end

  # GET /feature_groups/1
  # GET /feature_groups/1.json
  def show
  end

  # GET /feature_groups/new
  def new
    @feature_group = FeatureGroup.new
    @product = Product.find(params[:product_id])
  end

  # GET /feature_groups/1/edit
  def edit
  end

  # POST /feature_groups
  # POST /feature_groups.json
  def create
    @feature_group = FeatureGroup.new(feature_group_params)
    @product = Product.find(params[:product_id])
    @feature_group.product_id = @product.id
    respond_to do |format|
      if @feature_group.save
        format.html { redirect_to @product, notice: 'Feature group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @feature_group }
      else
        format.html { render action: 'new' }
        format.json { render json: @feature_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feature_groups/1
  # PATCH/PUT /feature_groups/1.json
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

  # DELETE /feature_groups/1
  # DELETE /feature_groups/1.json
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
    @feature = Feature.find(params[:feature_id])
    if @feature_group.features.includes(@feature) and !current_user.nil?
      if !@feature_group.singles?
        @feature_group.features.each do |f|
          if !f.likes.nil? then f.likes.where(:user_id => current_user.id).delete_all end
        end
      else
        unless @feature.likes.nil? then @feature.likes.where(:user_id => current_user.id).delete_all end
      end
      @feature.likes.build(:user_id => current_user.id, :up => params[:up])
      @feature.save
      @feature_group.save
    end
    redirect_to @feature_group.product
  end

  helper_method :can_user_vote
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature_group
      @feature_group = FeatureGroup.find(params[:id])
      @product = Product.find(params[:product_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_group_params
      params.require(:feature_group).permit(:name, :description, :product_id, :up)
    end
end

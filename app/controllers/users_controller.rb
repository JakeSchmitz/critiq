class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @pictures = @user.pictures
    if current_user.id == @user.id
      @pictures.build
    end
    if !@user.propic_id.nil?
      @propic = ImageAsset.find(@user.propic_id)
    else
      @propic = @user.pictures.last
    end
    @top_products = @user.products.order("rating desc")
  end

  # GET /users/new
  def new
    @user = User.new
    @user.pictures.build
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @user.pictures.build
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.propic_id = @user.pictures.last.id
    respond_to do |format|
      if @user.save
        #@user.pictures.build
        sign_in @user
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(user_params)
        #ImageAsset.new(:attachment => @user[:p, :user_id => @user.id)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def change_profile_picture
    if !params[:image_id].nil?
      @user = User.find(params[:user_id])
      @img = ImageAsset.find(params[:image_id])
      if @img.user_id == current_user.id
        @user.propic_id = params[:image_id]
        @user.save!
      end
    end
    redirect_to @user
  end

  def upload_picture
    @user = User.find(params[:user_id])
    if @user.id == current_user.id
      @user.pictures.build(params[:image_asset])
      @user.save
    end
    redirect_to @user
  end

  def dashboard 
    @user = User.find(params[:user_id])
    if current_user.id == @user.id
      prepare_dash_charts
    end
    respond_to do |format|
      format.html
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :username, :id, :age, :email, 
          :link, :password, :password_confirmation, :pictures, :profile_picture, :image_id, :product_id, :user_id,
          pictures_attributes: [:attachment_attributes, :attachment, :id, :pictures_attributes])
    end 

    def has_propic?
      @user = User.find(params[:id])
      !@user.propic_id.nil?
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please Log In!"
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def prepare_dash_charts
      seconds_per_day = (60 * 60 * 24)
      @products = @user.products
      # hash from product_id -> array of daily likes of product
      @product_likes = Hash.new
      # hash from product_id -> array of rating from each day
      @product_ratings = Hash.new
      # hashes from product_id -> gchart 
      @daily_likes = Hash.new
      @cummulative_ratings = Hash.new
      @products.each do |product|
        total_likes = 0
        cumm_rating = 0
        # how many days has this product existed
        existance_length = (Time.now.to_i - product.created_at.to_i) / seconds_per_day
        # array contains number of likes from date
        @product_likes[product.id] = Array.new(existance_length, 0)
        @product_ratings[product.id] = Array.new(existance_length, 0)
        dates = Array.new(existance_length)
        dates.each_with_index.map { |x,i| (existance_length - i).to_s }
        puts dates.to_s
        product.likes.order('created_at ASC').each do |like|
          day_liked = (like.created_at.to_i - product.created_at.to_i) / seconds_per_day
          @product_likes[product.id][day_liked] += 1
          @product_ratings[product.id][day_liked..existance_length] =   @product_ratings[product.id][day_liked..existance_length].map { |r| r + 10 }
          puts @product_ratings[product.id].to_s
          total_likes += 1
        end
        product.feature_groups.each do |fg|
          fg.features.each do |flike|
            day_liked = (flike.created_at.to_i - product.created_at.to_i) / seconds_per_day
            cumm_rating += 1
            @product_ratings[product.id][day_liked..existance_length] = @product_ratings[product.id][day_liked..existance_length].map { |r| r += 1 }
          end
        end
        puts @product_ratings[product.id].to_s
        @daily_likes[product.id] = Gchart.line(
                                      :type => 'line',
                                      :size => '250x200',
                                      :title => 'Daily Likes',
                                      :data => @product_likes[product.id],
                                      :axis_with_label => 'x, y',
                                      :axis_labels => [dates],
                                      :max_value => @product_likes[product.id].max,
                                      :min_value => 0,
                                      :legend => ['Daily Likes'],
                                      )
        @cummulative_ratings[product.id] = Gchart.line(
                                      :type => 'line',
                                      :size => '250x200',
                                      :title => 'Daily Rating',
                                      :data => @product_ratings[product.id],
                                      :axis_with_label => 'x, y',
                                      :axis_labels => [dates],
                                      :max_value => @product_ratings[product.id].last.to_i + 10,
                                      :min_value => 0,
                                      :legend => ['Daily Likes'],
                                      )
      end
    end
end

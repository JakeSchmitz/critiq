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
    @top_products = @user.products.where(active: true, hidden: false).order('rating DESC')
    @old_products = @user.products.where(active: false, hidden: false).order('rating DESC')
    @recent_activity = Activity.where(user_id: @user.id).where.not(activity_type: :create).order('timestamp DESC').limit(7)
    if !@user.propic_id.nil?
      @propic = ImageAsset.find(@user.propic_id)
    else
      @propic = @user.pictures.last
    end
  end

  # GET /users/new
  def new
    redirect_to signin_path
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @user.pictures.build
  end

  # POST /users
  # POST /users.json
  def create
    if !User.where(:email => params[:user][:email]).empty?
      flash[:error] = "We already have a user with this email address"
      redirect_to request.referer
    else
      @user = User.new(user_params)
      unless @user.pictures.first.nil?
        @user.propic_id = @user.pictures.last.id
      end
      respond_to do |format|
        if @user.save
          #@user.pictures.build
          NewUser.registration_confirmation(@user).deliver
          sign_in @user
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          #format.json { render action: 'show', status: :created, location: @user }
        else
          format.html { render action: 'new' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(user_params)
        unless @user.pictures.first.nil?
          @user.propic_id = @user.pictures.last.id
        end
        @user.save
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

  def change_profile_picture(image_id=nil)
    if !image_id.nil?
      @user = User.find(params[:user_id])
      @img = ImageAsset.find(params[:image_id])
      if @img.user_id == current_user.id
        @user.propic_id = params[:image_id]
        @user.save!
      end
    end
  end

  def upload_picture
    @user = User.find(params[:user_id])
    respond_to do |format|
      @image_asset = ImageAsset.new(params[:upload])
      if @user.id == current_user.id
        @user.pictures.build(params[:upload])
        @user.propic_id = @image_asset.id
        Activity.create(timestamp: Time.now, user_id: @user.id, activity_type: :create, resource_type: :image_asset, resource_id: @image_asset.id)
        if @user.save
          format.html {
            render :json => [@image_asset.to_jq_upload],
            :content_type => 'text/html',
            :layout => false
          }
          format.json { render json: {files: [@image_asset.to_jq_upload]}, status: :created, location: @image_asset}
        else
          format.json { render json: @image_asset.errors, status: :unprocessable_entity }
        end
      end
    end
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
      params.require(:user).permit(:name, :username, :id, :age, :email, :bio,
          :link, :password, :password_confirmation, :profile_picture, :image_id, :product_id, :user_id,
          pictures_attributes: [:attachment_attributes, :attachment, :attachable_id ,:id])
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

    def recent_activities 

    end

    def prepare_dash_charts
      @products = @user.products
      # hash from product_id -> array of daily likes of product
      @product_likes = Hash.new
      # hash from product_id -> array of rating from each day
      @product_ratings = Hash.new
      # hashes from product_id -> gchart 
      @daily_likes = Hash.new
      # Hash from product_id -> feature_group_id -> gchar (pie chart)
      @comparison_breakdowns = Hash.new
      @comparison_counts = Hash.new
      @cummulative_ratings = Hash.new
      likes_data
      features_data
      puts @comparison_counts.to_s
    end

    def likes_data 
      seconds_per_day = (60 * 60 * 24).to_i
      @products.each do |product|
        total_likes = 0
        cumm_rating = 0
        # how many days has this product existed
        existance_length = (Time.now.to_i - product.created_at.to_i) / seconds_per_day
        # array contains number of likes from date
        @product_likes[product.id] = Array.new(existance_length+1, 0)
        @product_ratings[product.id] = Array.new(existance_length+1, 0)
        product.likes.order('created_at ASC').each do |like|
          day_liked = ((like.created_at.to_i - product.created_at.to_i) / seconds_per_day) + 1
          if @product_likes[product.id][day_liked].nil?
            @product_likes[product.id][day_liked] = 0
          end
          puts product.name + " was liked on day: " + day_liked.to_s
          @product_likes[product.id][day_liked] += 1
          @product_ratings[product.id][day_liked..existance_length + 1] =   @product_ratings[product.id][day_liked..existance_length + 1].map { |r| r.to_i + 10 }
          puts @product_ratings[product.id].to_s
          total_likes += 1
        end
        product.feature_groups.each do |fg|
          fg.features.each do |flike|
            day_liked = ((flike.created_at.to_i - product.created_at.to_i) / seconds_per_day) + 1
            cumm_rating += 1
            @product_ratings[product.id][day_liked..existance_length + 1] = @product_ratings[product.id][day_liked..existance_length + 1].map { |r| r.to_i + 1 }
          end
        end
        @product_ratings[product.id][existance_length] = product.rating
        @daily_likes[product.id] = Gchart.line(
                                      :type => 'line',
                                      :size => '300x240',
                                      :title => 'Daily Likes',
                                      :data => @product_likes[product.id],
                                      :axis_with_labels => 'y',
                                      :axis_range => [[0, existance_length + 1]],
                                      :max_value => @product_likes[product.id].max.to_i + 2,
                                      :min_value => 0,
                                      :legend => ['total: ' + total_likes.to_s ],
                                      )
        @cummulative_ratings[product.id] = Gchart.line(
                                      :type => 'line',
                                      :size => '300x240',
                                      :title => 'Daily Rating',
                                      :data => @product_ratings[product.id],
                                      :axis_with_labels => 'y',
                                      :max_value => product.rating + 10,
                                      :min_value => 0,
                                      :legend => ['rating: ' + product.rating.to_s],
                                      )
      end
      puts @product_likes.to_s
    end

    def features_data
      seconds_per_day = (60 * 60 * 24)
      @products.each do |product|
        # abstraction here is necessary to avoid mixing feature_groups of products within User Dashboard
        # build hashes from feature_group to the arrays of data
        @comparison_counts[product.id] = Hash.new
        # build hashes from feature_group to the graphics for each product
        @comparison_breakdowns[product.id] = Hash.new
        # Generate data for comparative features
        product.feature_groups.where(singles: false).each do |fg|
          labels = Array.new
          # This FG gets its own hash from feature_id -> vote count
          @comparison_counts[product.id][fg.id] = Array.new
          total_likes = 0
          fg.features.each do |f|
            up_rating = f.likes.size - (2 * f.likes.where(up: false).size)
            @comparison_counts[product.id][fg.id] << up_rating.to_i
            total_likes += up_rating
          end
          if total_likes != 0
            fg.features.each_with_index do |f, i|
              labels += [f.name + " (" + (100 * @comparison_counts[product.id][fg.id][i]/ total_likes).to_s + "%)"] 
            end
          end
          if total_likes != 0
            @comparison_breakdowns[product.id][fg.id] = Gchart.pie(
                                        :data => @comparison_counts[product.id][fg.id], 
                                        :labels => labels,
                                        :size => '475x260')
          end
        end #End comparative features
        product.feature_groups.where(singles: true).each do |singles|
          # singleton votes in  from [p_id][fg_id][single_f_id] -> count array with only 2 indices (upvotes/ downvotes)
          @comparison_counts[product.id][singles.id] = Hash.new
          @comparison_counts[product.id][singles.id][:up] = Array.new(singles.features.size, 0)
          @comparison_counts[product.id][singles.id][:down] = Array.new(singles.features.size, 0)
          @comparison_counts[product.id][singles.id][:names] = Array.new(singles.features.size, '')
          singles.features.each_with_index do |f, i|  
            @comparison_counts[product.id][singles.id][:up][i] = f.likes.where(:up => true).size
            @comparison_counts[product.id][singles.id][:down][i] = f.likes.where(:up => false).size 
            @comparison_counts[product.id][singles.id][:names][i] = f.name
          end
          if !singles.features.empty?
            @comparison_breakdowns[product.id][singles.id] = Gchart.bar(
                                        data: [@comparison_counts[product.id][singles.id][:up], @comparison_counts[product.id][singles.id][:down]],
                                        :axis_with_labels => 'x,y',
                                        legend: ['Up', 'Down'],
                                        axis_labels: @comparison_counts[product.id][singles.id][:names],
                                        stacked: true,
                                        :bar_colors => 'ff0000,0000ff',
                                        horizontal: true,
                                        :bar_width_and_spacing => [30,20],
                                        title: 'Single Features',
                                        size: '475x260'
                                        )
            puts 'Here is a comparison Breakdown\n\n' + @comparison_counts.to_s
            puts 'blah\n'
            puts 'blah\n'
          end
        end
      end
    end
end

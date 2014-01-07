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
    @user.pictures.build
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
    respond_to do |format|
      if @user.save!
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
    @user.pictures.build
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
      set_user
      @img = ImageAsset.find(params[:image_id])
      if @img.user_id == @user.id
        @user.profile_picture = @img
      end
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
end

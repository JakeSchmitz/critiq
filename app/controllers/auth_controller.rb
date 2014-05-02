class AuthController < ApplicationController
	include SessionsHelper
	require 'open-uri'
  require 'open_uri_redirections'

	def new_facebook
		fbcode = request.env['omniauth.auth'].credentials.token
		@fb_params = Koala::Facebook::API.new(fbcode)
		profile = @fb_params.get_object("me")
		pic_url = "http://graph.facebook.com/"+profile["id"]+"/picture?type=large"
		create_social_media profile["name"], profile["email"], pic_url, fbcode
	end

	def new_twitter
		credentials = request.env['omniauth.auth'].credentials
		client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = ENV["TWITTER_KEY"]
		  config.consumer_secret     = ENV["TWITTER_SECRET"]
		  config.access_token        = credentials.token
		  config.access_token_secret = credentials.secret
		end
		user = client.current_user
		sign_in_if_exists User.where(screen_name: user.screen_name).first, credentials.token 
		session[:twit_name] = user.name
		session[:twit_pic] = "http://" + user.profile_image_uri.host + user.profile_image_uri.path
		session[:access_token] = client.access_token
		session[:screen_name] = user.screen_name
	end

	def create_twitter
		email = params[:user][:email]
		@user = create_and_email_user session[:twit_name], email, session[:access_token]
		create_profile_picture @user, session[:twit_pic]
		sign_in_if_exists @user, session[:access_token]
	end

	def new_linkedin
		credentials = request.env['omniauth.auth'].credentials
		LinkedIn.configure do |config|
	  	config.token = ENV["LINKEDIN_KEY"]
	  	config.secret = ENV["LINKEDIN_SECRET"]
		end
		client = LinkedIn::Client.new
		client.authorize_from_access credentials.token, credentials.secret
		profile = client.profile fields: [:email_address, :first_name, :last_name, :picture_url]
		name = "#{profile.first_name profile.last_name}" 
		create_social_media name, profile.email_address, profile.picture_url, credentials.token	
	end

	private

	def create_social_media name, email, pic_url, token
		if User.where(email: email).empty?
			user = create_and_email_user(name, email, token)
		else
			user = User.find_by email: email
			current_user = user
		end
		create_profile_picture user, pic_url
		sign_in_if_exists user, token
	end

	def sign_in_if_exists user, token
		if user
			sign_in user, token
			redirect_to user
		else
			redirect_to signin_url, notice: "Authentication failed! Please sign in with email and password"
		end	
	end

	def create_and_email_user name, email, token
		user = User.create(name: name, email: email, password: token)
		begin
			NewUser.registration_confirmation(@user).deliver
		rescue Exception
      flash[:warning] = "Confirmation of your signup failed to be delivered to your inbox, please check your account's email at some point"
    end
		user.save
		user
	end

	def create_profile_picture user, pic_url
		if user.pictures.empty? 
			# propic = user.pictures.build(attachment: open(process_uri(pic_url).to_s))
			# user.propic_id = propic.id
			# propic.save
			# user.save
		end
	end
end
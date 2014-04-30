class AuthController < ApplicationController
	include SessionsHelper
	require 'open-uri'
  require 'open_uri_redirections'
	def new_facebook
		fbcode = request.env['omniauth.auth']['credentials'].token
		@fb_params = Koala::Facebook::API.new(fbcode)
		profile = @fb_params.get_object("me")
		if User.where(email: profile["email"]).empty?
			@user = User.create(name: profile["name"], email: profile["email"], password: fbcode)
			begin
				NewUser.registration_confirmation(@user).deliver
			rescue Exception
        flash[:warning] = "Confirmation of your signup failed to be delivered to your inbox, please check your account's email at some point"
      end
			@user.save
		else
			@user = User.find_by email: profile["email"]
			current_user=@user
		end
		if @user.pictures.empty?
			propic = @user.pictures.build(attachment: open(process_uri("http://graph.facebook.com/"+profile["id"]+"/picture?type=large").to_s))
			@user.propic_id = propic.id
			propic.save
			@user.save
		end
		if @user
			fb_sign_in(@user, fbcode)
			redirect_to @user
		else
			redirect_to signin_url, notice: "Facebook authentication failed! Please sign in with email and password"
		end
	end

	def new_twitter
		client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = ENV["TWITTER_KEY"]
		  config.consumer_secret     = ENV["TWITTER_SECRET"]
		  config.access_token        = request.env['omniauth.auth'].credentials.token
		  config.access_token_secret = request.env['omniauth.auth'].credentials.secret
		end
		user = client.current_user
		profile_url =  user.profile_image_uri.host + user.profile_image_uri.path
		session[:twit_name] = user.name
		session[:twit_pic] = "http://" + profile_url
		session[:access_token]= client.access_token
	end

	def create_twitter
		email = params[:user][:email]
		if User.where(email: email).empty?
			@user = User.create(name: session[:twit_name], email: email, password: session[:access_token])
			begin
				NewUser.registration_confirmation(@user).deliver
			rescue Exception
        flash[:warning] = "Confirmation of your signup failed to be delivered to your inbox, please check your account's email at some point"
      end
			@user.save
		else
			@user = User.find_by email: email
			current_user=@user
		end
		if @user.pictures.empty?
			propic = @user.pictures.build(attachment: open(process_uri(session[:twit_pic]).to_s))
			@user.propic_id = propic.id
			propic.save
			@user.save
		end
		if @user
			tw_sign_in(@user, session[:access_token])
			redirect_to @user
		else
			redirect_to signin_url, notice: "Twitter authentication failed! Please sign in with email and password"
		end
	end
end
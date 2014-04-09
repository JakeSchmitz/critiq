class FacebookAuthController < ApplicationController
	include SessionsHelper
	require 'open-uri'
  require 'open_uri_redirections'
	def new
		fbcode = request.env['omniauth.auth']['credentials'].token
		@fb_params = Koala::Facebook::API.new(fbcode)
		profile = @fb_params.get_object("me")
		puts profile
		if User.where(email: profile["email"]).empty?
			@user = User.create(name: profile["name"], email: profile["email"], password: fbcode)
			@user.save
		else
			@user = User.find_by email: profile["email"]
			current_user=@user
		end
		#propic = @user.pictures.create(prodcess_uri("http://graph.facebook.com/"+profile["id"]+"/picture?type=large").info.image)
		#@user.propic_id = propic.id
		#@user.save
		if @user
			fb_sign_in(@user, fbcode)
			redirect_to @user
		else
			redirect_to signin_url, notice: "Facebook authentication failed! Please sign in with email and password"
		end
	end
end
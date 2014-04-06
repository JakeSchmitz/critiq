class FacebookAuthController < ApplicationController
	include SessionsHelper
	def new
		@fb_params = Koala::Facebook::API.new(request.env['omniauth.auth']['credentials'].token)
		profile = @fb_params.get_object("me")
		if !User.where email: profile["email"].empty?
			@user = User.create(name: profile["name"], email: profile["email"], password: rand_pwd)
			@user.save
		else
			@user = User.where(name: profile["name"], email: profile["email"]).first
		end
		if !@user.nil?
			fb_sign_in(@user, request.env['omniauth.auth']['credentials'].token)
			redirect_to @user
		else
			redirect_to signin_url, notice: "Facebook authentication failed! Please sign in with email and password"
		end
	end
end
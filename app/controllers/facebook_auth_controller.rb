class FacebookAuthController < ApplicationController
	include SessionsHelper
	def new
		@fb_params = Koala::Facebook::API.new(request.env['omniauth.auth']['credentials'].token)
		profile = @fb_params.get_object("me")
		if !User.where email: profile["email"].empty?
			@user = User.new(name: profile["name"], email: profile["email"], password: rand_pwd)
			@user.save
		else
			@user = User.where(email: profile["email"]).first
		end
		fb_sign_in(@user, request.env['omniauth.auth']['credentials'].token)
		redirect_to @user
	end
end
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
			begin
				NewUser.delay.registration_confirmation(@user).deliver
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
end
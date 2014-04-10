require 'user'
class SessionsController < ApplicationController
	def new

	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			#Check user in
			sign_in user
			#flash.now[:success] = user.name + ' successfully signed in'
			redirect_to user
		else
			#Complain
			flash.now[:error] = 'Invalid email/ password combination'
			render 'new'
		end
	end

	def destroy 
		sign_out
		redirect_to root_url
	end
end


class ActivitiesController < ApplicationController
	def new 
	end

	def edit
	end

	def destroy 
	end

	def user_activities(user_id)
		@user = Users.find(user_id)
		@recent_activities = Activities.where(user_id: user_id).order('timestamp DESC').limit(10)
	end
	# move to User model
end

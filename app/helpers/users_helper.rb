module UsersHelper
	def has_image?
		@user = User.find(params[:id])
		!@user.pictures.empty?
	end
end

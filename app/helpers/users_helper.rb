module UsersHelper
	def has_image?
		@user = User.find(params[:id])
		!@user.pictures.empty?
	end

	def has_propic?
		@user = User.find(params[:id])
		!@user.propic_id.nil?
	end
end

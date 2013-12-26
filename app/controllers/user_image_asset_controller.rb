class UserImageAssetController < ApplicationController
	def create
		@user_image_asset = ImageAsset.new(user_image_asset_params)
		@user_image_asset.attachment = params[:image_asset][:attachment]
		@user_image_asset.save
		respond_with @image_asset
	end

	private

	def user_image_asset_params
		params.require(:user_image_asset).permit(:title, :user_id, :user_image_asset_attributes)
	end
end

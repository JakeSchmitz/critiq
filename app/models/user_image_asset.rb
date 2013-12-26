class UserImageAsset < ImageAsset
	belongs_to :user
	attr_accessible :user_image_attributes
end

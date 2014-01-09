class ImageAsset < ActiveRecord::Base
	belongs_to :attachable
	has_attached_file :attachment, 
  	:styles => {:large => "x600>", :medium => "x300>", :thumb => "x100>" }, 
  	:default_url => "/images/missing-image-:style.jpg"
  attr_accessible :attachment, :user_id, :attachable_id, :attachment_attributes
end

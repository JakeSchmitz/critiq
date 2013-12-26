class ImageAsset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
	has_attached_file :attachment, 
  	:styles => {:large => "x640>", :medium => "x300>", :thumb => "x100>" }, 
  	:default_url => "/images/missing-image.jpg"
  attr_accessible :attachment, :user_id, :attachment_attributes
end

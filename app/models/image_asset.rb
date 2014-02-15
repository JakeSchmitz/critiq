class ImageAsset < ActiveRecord::Base
	belongs_to :attachable
	has_attached_file :attachment, 
  	:styles => {:large => "x600>", :medium => "x300>", :thumb => "x100>" }, 
  	:default_url => "/images/missing-image-:style.jpg"										,
    :storage        => :s3                                                ,
	  :s3_credentials => {:bucket            => ENV['AWS_BUCKET']				,
	                      :access_key_id     => ENV['AWS_ACCESS_KEY_ID'    ],
	                      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']},
	  :s3_endpoint 		=> 's3-us-west-2.amazonaws.com' ,
	  :s3_protocol    => "https"                  
  attr_accessible :attachment, :user_id, :attachable_id, :attachment_attributes
end

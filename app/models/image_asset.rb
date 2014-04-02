class ImageAsset < ActiveRecord::Base
	belongs_to :attachable
	has_attached_file :attachment, 
  	styles: {large: "x600>", medium: "x300>", thumb: "x100>" }, 
  	default_url: "/images/missing-product.jpg"										,
    storage: :s3                                                ,
    s3_endpoint: 's3-us-west-2.amazonaws.com',
	  s3_credentials: {s3_endpoint: 		    's3-us-west-2.amazonaws.com' ,
	  										bucket:            ENV['AWS_BUCKET']				,
	                      access_key_id:     ENV['AWS_ACCESS_KEY_ID'    ],
	                      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']},
	  s3_protocol: "https"                  
  attr_accessible :attachment, :user_id, :attachable_id, :product_id, :attachment_attributes

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:attachment_file_name),
      "size" => read_attribute(:attachment_file_size),
      "url" => self.attachment.url(:thumb),
      "delete_url" => image_asset_path(self),
      "delete_type" => "DELETE" 
    }
  end
end

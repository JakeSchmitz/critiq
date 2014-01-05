class Product < ActiveRecord::Base
	belongs_to :user, :foreign_key => "user_id"
	has_many :features
	has_one :product_pic, class_name: "ImageAsset", foreign_key: "attachable_id", :as => :attachable, dependent: :destroy, :autosave => true
  accepts_nested_attributes_for :product_pic, :allow_destroy => true
	has_many :pictures, class_name: "ImageAsset", foreign_key: "attachable_id", :as => :attachable, dependent: :destroy, :autosave => true
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  accepts_nested_attributes_for :features, :allow_destroy => true
  attr_accessible :name, :description, :pictures, :pictures_attributes, :product_pic, :product_pic_attricbutes, :features
  after_update :save_everything
  private
    def save_everything
    	self.product_pic = self.pictures.last
      self.pictures.each do |asset| 
      	asset.product_id = self.id
        asset.save!
      end 
      self.features.each do |f|
      	f.product = self
      	f.save!
      end
    end 

    def has_pictures?
    	!self.picture.empty?
    end
end

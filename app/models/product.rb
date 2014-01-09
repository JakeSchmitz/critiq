class Product < ActiveRecord::Base
	belongs_to :user, :foreign_key => "user_id"
  has_many :likes, :as => :likeable
	has_many :features
  has_many :comments, :as => :commentable
	has_one :product_pic, class_name: "ImageAsset", foreign_key: "attachable_id", :as => :attachable, dependent: :destroy, :autosave => true
  accepts_nested_attributes_for :product_pic, :allow_destroy => true
	has_many :pictures, class_name: "ImageAsset", foreign_key: "attachable_id", :as => :attachable, dependent: :destroy, :autosave => true
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  accepts_nested_attributes_for :features, :allow_destroy => true
  accepts_nested_attributes_for :comments, :allow_destroy => true
  attr_accessible :name, :description, :rating, :pictures, :pictures_attributes, :product_pic, :product_pic_attricbutes, :features, likes: [:product_id, :user_id]
  after_update :save_everything

  def liked?(id, type)
    if get_likes(id, type).length > 0
      return true
    end
    return false
  end

  private

    def get_likes(id, type)
      return Likes.where(:user_id => self.id, :likeable_type => type, :likeable_id => id)
    end

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

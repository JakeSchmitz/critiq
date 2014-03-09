class Feature < ActiveRecord::Base
	has_many :pictures, class_name: "ImageAsset", foreign_key: "attachable_id", :as => :attachable, dependent: :destroy, :autosave => true
	belongs_to :feature_group, :foreign_key => "feature_group_id"
  has_many :likes, class_name: "Like", foreign_key: "likeable_id", :as => :likeable, dependent: :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true

  attr_accessible :name, :description, :pictures, :pictures_attributes, :image_asset
  after_update :save_pictures

  def percent_like
    if self.likes.empty?
      return 0
    else
      return self.likes.where(up: true).size.to_f / self.likes.size.to_f
    end
  end

  private

    def save_pictures
      self.pictures.each do |asset| 
        asset.feature_id = self.id
        asset.user_id = self.feature_group.product.user.id
        asset.product_id = self.feature_group.product.id
        asset.save!
      end 
    end 

end

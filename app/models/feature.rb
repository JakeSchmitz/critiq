class Feature < ActiveRecord::Base
	has_many :pictures, class_name: "ImageAsset", foreign_key: "attachable_id", :as => :attachable, dependent: :destroy, :autosave => true
	belongs_to :product, :foreign_key => "product_id"
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  attr_accessible :name, :description, :pictures, :pictures_attributes
  after_update :save_pictures

  private

    def save_pictures
      self.pictures.each do |asset| 
        asset.feature_id = self.id
        asset.save!
      end 
    end 

end

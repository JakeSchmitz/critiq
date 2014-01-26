class FeatureGroup < ActiveRecord::Base
	has_many :features, dependent: :destroy, :autosave => true
	belongs_to :product, :foreign_key => "product_id"
	accepts_nested_attributes_for :features, :allow_destroy => true
	attr_accessible :name, :features, :description, :product_id, :product
end

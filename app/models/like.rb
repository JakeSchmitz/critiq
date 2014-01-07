class Like < ActiveRecord::Base
	belongs_to :product
	attr_accessible :product, :product_id, :user_id
end

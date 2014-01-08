class Like < ActiveRecord::Base
	belongs_to :likeable
	belongs_to :user
	attr_accessible :user, :product_id, :user_id, :likeable_id, :likeable_type
end

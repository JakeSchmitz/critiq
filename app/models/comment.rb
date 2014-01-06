class Comment < ActiveRecord::Base
	belongs_to :product
	belongs_to :user
	attr_accessible :product_id, :user_id, :title, :body
end

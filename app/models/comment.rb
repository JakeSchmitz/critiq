class Comment < ActiveRecord::Base
	belongs_to :commentable, :polymorphic => true
	belongs_to :user
	attr_accessible :product_id, :user_id, :title, :body, :created_at, :user
end

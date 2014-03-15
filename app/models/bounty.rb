class Bounty < ActiveRecord::Base
	belongs_to :product
	has_many :comments, as: :commentable, dependent: :destroy
	attr_accessible :product, :comments, :question, :response_count, :product_id

	def top_responses 
		return self.comments.order('rating DESC')
	end
end

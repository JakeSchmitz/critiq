class Comment < ActiveRecord::Base
	belongs_to :commentable, polymorphic: true
	belongs_to :user
	has_many :upvotes, class_name: "Like", foreign_key: "likeable_id", as: :likeable
	has_many :downvotes, class_name: "Like", foreign_key: "likeable_id", as: :likeable
	attr_accessible :product_id, :user_id, :title, :body, :created_at, :user

	def product 
		case self.product_id
		when nil
			case self.commentable_type
			when 'bounty'
				self.commentable.bounty
			when 'feature'
				self.commentable.feature_group.product
			when 'product'
				self.commentable
			else
				nil
			end
		else 
			Product.find(product_id)
		end

	end
end

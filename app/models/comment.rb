class Comment < ActiveRecord::Base
	belongs_to :commentable, polymorphic: true
	belongs_to :user
	has_many :likes, class_name: "Like", foreign_key: "likeable_id", as: :likeable
	attr_accessible :product_id, :user_id, :title, :body, :created_at, :user

	def product 
		case self.product_id
		when nil
			case self.commentable_type.downcase
			when 'Bounty'
				self.commentable
			when 'Feature'
				self.commentable.feature_group.product
			when 'Product'
				self.commentable
			else
				nil
			end
		else 
			Product.find(product_id)
		end
	end

	def upvotes
		self.likes.where(up: true)
	end

	def downvotes
		self.likes.where(up: false)
	end
end

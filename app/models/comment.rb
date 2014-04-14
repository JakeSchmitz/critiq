class Comment < ActiveRecord::Base
	belongs_to :commentable, polymorphic: true
	belongs_to :user
	has_many :likes, class_name: "Like", foreign_key: "likeable_id", as: :likeable
	attr_accessible :product_id, :user_id, :title, :body, :created_at, :user

	def product 
		case self.commentable_type.downcase
		when 'bounty'
			self.commentable.product
		when 'feature'
			self.commentable.feature_group.product
		when 'product'
			self.commentable
		else
			if self.product_id
				Product.find(self.product_id)
			else
				nil
			end
		end
	end

	def upvotes
		self.likes.where(up: true)
	end

	def downvotes
		self.likes.where(up: false)
	end
end

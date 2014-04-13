class Comment < ActiveRecord::Base
	belongs_to :commentable, polymorphic: true
	belongs_to :user
	has_many :likes, class_name: "Like", foreign_key: "likeable_id", as: :likeable
	attr_accessible :product_id, :user_id, :title, :body, :created_at, :user, :parent_id, :ancestry
	has_ancestry

	def product 
		case self.product_id
		when nil
			case self.commentable_type.downcase
			when 'Bounty'
				self.commentable.product
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

	def path_to_reply #used in the polymorphic_url method
		if self.commentable.class != Product 
			[self.commentable.product, self.commentable, self]
		else
			[self.commentable, self ]
		end
	end

	def reply # used in the reply form
		parent_comment = self.parent.path_to_reply
		parent_comment.pop
		parent_comment << self
	end
end

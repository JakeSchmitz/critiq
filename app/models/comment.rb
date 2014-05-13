class Comment < ActiveRecord::Base
	belongs_to :commentable, polymorphic: true
	belongs_to :user
	has_many :likes, class_name: "Like", foreign_key: "likeable_id", as: :likeable
	attr_accessible :product_id, :user_id, :title, :body, :created_at, :user, :parent_id, :ancestry, :rating
	after_create :make_comment_activity
	has_ancestry

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

	def modified?
		updated_at == created_at
	end

	def upvotes
		likes.where(up: true)
	end

	def downvotes
		likes.where(up: false)
	end

	def vote user, direction
		likes.where(:user_id => user.id).delete_all
		likes.create(:user_id => user.id, :up => direction, :product_id => product_id)
		self.rating = upvotes.size - downvotes.size
		save
	end

	def path #used in the polymorphic_url method
		if self.commentable.class != Product 
			[self.commentable.product, self.commentable, self]
		else
			[self.commentable, self ]
		end
	end

	def reply # used in the reply form
		parent_comment = self.parent.path
		parent_comment.pop
		parent_comment << self
	end

private
	
	def make_comment_activity
		Activity.create(timestamp: Time.now, user_id: self.user_id, activity_type: :comment, resource_type: commentable.class.name.downcase, resource_id: commentable_id)
	end
end

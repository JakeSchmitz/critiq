class Like < ActiveRecord::Base
	#Association for only likeable things like comparison features and products
	belongs_to :likeable, polymorphic: true
	belongs_to :user
	attr_accessible :user, :user_id, :product_id, :likeable_id, :likeable_type, :up, :upvoteable, :downvoteable
	after_create :make_like_activity
	def product 
		case self.likeable_type.downcase
		when 'bounty'
			self.likeable.product
		when 'feature'
			self.likeable.feature_group.product
		when 'product'
			self.likeable
		when 'comment'
			self.likeable.product
		else
			nil
		end
	end

private
	
	def make_like_activity
		Activity.create(timestamp: Time.now, user_id: user_id, activity_type: :like, resource_type: :product, resource_id: likeable_id)
	end


end

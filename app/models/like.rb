class Like < ActiveRecord::Base
	#Association for only likeable things like comparison features and products
	belongs_to :likeable, polymorphic: true
	belongs_to :user
	attr_accessible :user, :user_id, :likeable_id, :likeable_type, :up, :upvoteable, :downvoteable

	def product 
		case self.likeable_type.downcase
		when 'Bounty'
			self.likeable.product
		when 'Feature'
			self.likeable.feature_group.product
		when 'Product'
			self.likeable
		else
			nil
		end
	end
end

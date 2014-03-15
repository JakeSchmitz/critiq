class Like < ActiveRecord::Base
	#Association for only likeable things like comparison features and products
	belongs_to :likeable, polymorphic: true
	belongs_to :user
	attr_accessible :user, :user_id, :likeable_id, :likeable_type, :up, :upvoteable, :downvoteable
end

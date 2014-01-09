class Like < ActiveRecord::Base
	belongs_to :likeable
	belongs_to :user
	attr_accessible :user, :user_id, :likeable_id, :likeable_type
end

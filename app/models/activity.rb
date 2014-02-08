class Activity < ActiveRecord::Base
	classy_enum_attr :activity_type
	classy_enum_attr :resource_type
	belongs_to :user
	attr_accessible :activity_type, :resource_type, :resource_id, :user_id, :timestamp
end

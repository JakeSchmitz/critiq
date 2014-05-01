class Activity < ActiveRecord::Base
	classy_enum_attr :activity_type
	classy_enum_attr :resource_type
	belongs_to :user
	attr_accessible :activity_type, :resource_type, :resource_id, :user_id, :timestamp

	def product 
		case self.activity_type
		when 'comment'
			Comment.find(self.resource_id).product
		when 'like'
			Like.find(self.resource_id).product
		when 'feature'
			Feature.find(self.resource_id).product
		when 'product'
			Product.where(id: self.resource_id).first
		else
			case self.resource_type.to_s.downcase
			when 'comment'
				Comment.find(self.resource_id).product
			when 'feature'
				Feature.find(self.resource_id).feature_group.product
			when 'product'
				Product.where(id: self.resource_id).first
			else
				nil
			end
		end
	end

end

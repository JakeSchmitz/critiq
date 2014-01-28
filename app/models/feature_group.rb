class FeatureGroup < ActiveRecord::Base
	has_many :features, dependent: :destroy, :autosave => true
	belongs_to :product, :foreign_key => "product_id"
	accepts_nested_attributes_for :features, :allow_destroy => true
	attr_accessible :name, :features, :description, :product_id, :product

	def can_user_vote(current_user)
    if !current_user.nil? 
      self.features.each do |f|
        f.upvotes.each do |l|
          if l.user_id == current_user.id
            return false
          end
        end
      end
      return true
    end
    return false
  end
end

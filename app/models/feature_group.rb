class FeatureGroup < ActiveRecord::Base
	has_many :features, dependent: :destroy, autosave: true
	belongs_to :product, foreign_key: "product_id"
	accepts_nested_attributes_for :features, allow_destroy: true

	attr_accessible :name, :features, :description, :product_id, :product, :up, :singles, features: [:pictures]

	def can_user_vote(current_user)
    if !current_user.nil? 
      return true
      self.features.each do |f|
        return false if f.upvotes.includes(user_id: current_user.id) or f.downvotes.include(user_id: current_user.id)
      end
      return true
    end
    return false
  end

end

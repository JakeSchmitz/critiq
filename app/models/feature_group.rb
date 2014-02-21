class FeatureGroup < ActiveRecord::Base
	has_many :features, dependent: :destroy, :autosave => true
	belongs_to :product, :foreign_key => "product_id"
	accepts_nested_attributes_for :features, :allow_destroy => true
	attr_accessible :name, :features, :description, :product_id, :product

	def can_user_vote(current_user)
    if !current_user.nil? 
      self.features.each do |f|
        return false if f.upvotes.includes(:user_id => current_user.id) or f.downvotes.include(:user_id => current_user.id)
      end
      return true
    end
    return false
  end

  def upvote(feature, current_user)
    if self.features.includes(feature) and !current_user.nil?
      if !self.singles?
        self.features.each do |f|
          f.upvotes.find(:user_id => current_user).delete_all
          f.downvotes.find(:user_id => current_user).delete_all
        end
      else
        feature.upvotes.find(:user_id => current_user).delete_all
        feature.downvotes.find(:user_id => current_user).delete_all
      end
      feature.upvotes.build(:user => current_user)
      feature.save
      self.save
    end
  end
end

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
  end # this method might be returning too early
  # why not where instead of includes?
  #include should be includes

  def reset_likes_for user, feature
    if singles?
      feature.delete_likes_from user
      {:updated_feature => feature}
    else
      features.each do |f| 
        if !f.likes.where(user_id: user.id).empty?
          f.delete_likes_from user
          return {:old_count => f.upvotes, :updated_feature => f}
        end
      end
      {old_count: 0, updated_feature: feature } 
    end
  end

  def vote_on feature, user, direction
    reset_feature = reset_likes_for user, feature
    old_count = reset_feature[:old_count]
    updated_feature = reset_feature[:updated_feature]
    feature.likes.create(:user_id => user.id, :up => direction)
    old_count = feature.percent_like if singles?
    Feature.to_vote_json(feature, updated_feature, old_count)
  end

end

class Feature < ActiveRecord::Base
	has_many :pictures, class_name: "ImageAsset", foreign_key: "attachable_id", as: :attachable, dependent: :destroy, autosave: true
	belongs_to :feature_group, foreign_key: "feature_group_id"
  has_many :likes, class_name: "Like", foreign_key: "likeable_id", as: :likeable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  attr_accessible :name, :description, :pictures, :pictures_attributes, :image_asset, pictures: [:attachment]
  after_update :save_pictures

  def percent_like
    if self.likes.empty?
      0
    else
      ratio = likes.where(up: true).size.to_f / self.likes.size.to_f
      (ratio * 100.0).round(2)
    end
  end

  def is_single?
    self.feature_group.singles?
  end

  def profile_pic
    if !self.pictures.empty?
      return self.pictures.last
    else
      return nil  
    end
  end

  def profile_pic_url(size=:large)
    case self.profile_pic
    when nil
      '/images/missing-product.jpg'
    else
      self.profile_pic.attachment.url(size)
    end
  end

  def product 
    self.feature_group.product
  end

  def rating
    upvotes - downvotes
  end

  def upvotes 
    self.likes.where(:up => true).size
  end

  def downvotes 
    self.likes.where(:up => false).size
  end

  def delete_likes_from user
    likes.where(:user_id => user).delete_all
  end

  def self.to_vote_json voted_feature, updated_feature, old_count
    vote = updated_feature.attributes
    vote['upvotes'] = voted_feature.upvotes
    vote['downvotes'] = voted_feature.downvotes
    vote['oldCount'] = old_count
    vote.to_json
  end

  private

    def save_pictures
      self.pictures.each do |asset| 
        asset.feature_id = self.id
        asset.user_id = self.feature_group.product.user.id
        asset.product_id = self.feature_group.product.id
        asset.save!
      end 
    end 

end

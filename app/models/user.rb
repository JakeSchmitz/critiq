class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  has_many :products
  has_many :comments
  has_many :likes
  has_one :profile_picture, class_name: "ImageAsset", foreign_key: "attachable_id", :as => :attachable, dependent: :destroy, :autosave => true
  validates :name, :presence => true
  validates :email, :presence => true
  attr_accessible :idxw, :name, :email, :age, :password, :password_confirmation, :image_asset, :remember_token, :link, :user_id, :product_id,
                  :pictures, :attachment, :attachment_attributes, :pictures_attributes, :profile_picture, :profile_picture_attibutes
  has_secure_password
  has_many :pictures, class_name: "ImageAsset", foreign_key: "attachable_id", :as => :attachable, dependent: :destroy, :autosave => true
  accepts_nested_attributes_for :pictures, :allow_destroy => true

  after_update :save_pictures

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def save_pictures
      self.pictures.each do |asset| 
        asset.user_id = self.id
        asset.save!
      end 
    end 

end

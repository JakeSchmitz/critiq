class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  has_many :products
  has_many :comments
  has_many :likes
  has_many :activities
  
  validates :name, :presence => true
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  attr_accessible :id, :name, :email, :age, :password, :password_confirmation, :image_asset, :remember_token, :link, :user_id, :product_id,
                  :pictures, :attachment, :attachment_attributes, :pictures_attributes, :profile_picture, :profile_picture_attibutes
  has_secure_password
  has_many :pictures, class_name: "ImageAsset", foreign_key: "attachable_id", :as => :attachable, :autosave => true
  accepts_nested_attributes_for :pictures, :allow_destroy => true

  after_update :save_pictures

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def swagger 
    swag = 0
    self.products.each do |p|
      swag += (p.rating.nil? ? 0 : p.rating)
    end
    return swag
  end

  def lovers
    luvrs = 0
    self.products.each do |p|
      luvrs += p.likes.length
    end
    return luvrs
  end

  def profile_pic
    if !self.propic_id.nil?
      return ImageAsset.find(self.propic_id)
    elsif !self.pictures.last.nil?
      return self.pictures.first
    end
  end

  def has_pics?
    return !self.pictures.empty?
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

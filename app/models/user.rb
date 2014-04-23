class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  has_many :products, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :activities, dependent: :destroy
  
  validates :name, presence: true
  validates_confirmation_of :password
  validates :password, length: { minimum: 6 }
  validates_presence_of :password, on: :create
  validates_presence_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_uniqueness_of :email
  attr_accessible :id, :name, :email, :age, :password, :password_confirmation, :image_asset, :remember_token, :link, :user_id, :product_id,
                  :pictures, :attachment, :attachment_attributes, :pictures_attributes, :profile_picture, :profile_picture_attibutes
  has_secure_password
  has_many :pictures, class_name: "ImageAsset", foreign_key: "attachable_id", as: :attachable, autosave: true
  accepts_nested_attributes_for :pictures, allow_destroy: true

  after_update :save_pictures

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  #Swagger is a users Critiqr rating
  def swagger 
    critiq_rating + like_rating
  end

  def creator_heat
    rating = 0
    self.products.each do |p|
      rating += p.rating 
    end
    rating
  end

  def lovers
    luvrs = 0
    self.products.each do |p|
      luvrs += p.likes.length
    end
    return luvrs
  end

  def profile_pic
    p 'PROPIC = ' + self.propic_id.to_i.to_s + '\n\n/n/n'
    if self.propic_id
      ImageAsset.find(self.propic_id)
    elsif !self.pictures.empty?
      self.pictures.last
    else
      nil
    end
  end

  def profile_pic_url(size=:large)
    p self.profile_pic
    case self.profile_pic
    when nil
      '/images/missing-user-avatar.png'
    else
      self.profile_pic.attachment.url(size)
    end
  end

  def has_pics?
    return !self.pictures.empty?
  end

  def first_name
    self.name.split(' ')[0]
  end

  def self.test_reg_email(user)
    NewUser.registration_confirmation(user).deliver
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

    # Compute user's rating contributed by their critiq's
    def critiq_rating
      user_comments = Comment.where(user_id: self.id)
      rating = 0
      user_comments.each do |c|
        rating += c.upvotes.size * 10
        rating -= c.downvotes.size * 2
      end
      # Grant creator permissions if this user for the first time has over 1000 creator heat
      if !self.creator and rating > 1000 
        self.update_attribute(creator: true)
      end
      rating
    end

    def like_rating
      feature_likes = Like.where(likeable_type: 'Feature')
      rating = 0 || feature_likes.size
      rating -= Like.where(likeable_type: 'Comment', up: false, user_id: self.id).size
    end

end

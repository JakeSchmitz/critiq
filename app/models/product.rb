class Product < ActiveRecord::Base
	belongs_to :user, foreign_key: "user_id"
  validates :name, presence: true
  validates :description, presence: true
  has_many :likes, as: :likeable, dependent: :destroy
	has_many :feature_groups, dependent: :destroy
  has_many :bounties, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
	has_one :product_pic, class_name: "ImageAsset", foreign_key: "attachable_id", as: :attachable, autosave: true
  accepts_nested_attributes_for :product_pic, allow_destroy: true
	has_many :pictures, class_name: "ImageAsset", foreign_key: "attachable_id", as: :attachable, autosave: true
  accepts_nested_attributes_for :pictures, allow_destroy: true
  accepts_nested_attributes_for :feature_groups, allow_destroy: true
  accepts_nested_attributes_for :comments, allow_destroy: true
  attr_accessible :name, :description, :rating, :link, :likes, :video_url, :pictures, :active, :pictures_attributes, :product_pic, :hidden, :password, :access_list, feature_groups: [features: [:pictures]], likes: [:product_id, :user_id]
  before_create :setup_feature_bounty_content
  after_create :make_create_activity

  def liked?(id, type)
    if get_likes(id, type).length > 0
      return true
    end
    return false
  end

  def can_be_accessed_by user
    if !user and hidden
      return false
    end
    !hidden || parsed_list.include?(user.id)
  end

  def parsed_list
    access_list.split(",").map(&:to_i)
  end

  #Return a unique array of users that have liked elements of this product
  def followers 
    lovers = []
    self.likes.each do |l|
      lovers << l.user
    end
    self.feature_groups.each do |fg|
      fg.features.each do |f|
        f.likes.each do |l| 
          lovers << l.user
        end
      end
    end
    return lovers.uniq
  end

  def self.top_products
    order('rating desc')
  end

  def top_users
    return self.followers.sort { |x, y| x.swagger <=> y.swagger }
  end

  def profile_pic
    if !self.product_pic.nil? and !self.product_pic.attachment.nil?
      return self.product_pic
    elsif !self.pictures.empty?
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

  def rand_pic
    if !self.pictures.empty?
      return self.pictures.to_a[rand(self.pictures.size)]
    else
      return nil
    end
  end # use sample

  def single_features
    case self.feature_groups.where(singles: true).first
    when nil
      self.feature_groups.create(singles: true)
    else
      self.feature_groups.where(singles: true).first
    end
  end

  def single
    feature_groups.where(singles: true).first
  end

  def comparisons
    feature_groups.where singles: false
  end

  def sorted_comments
    comments.order 'rating desc'
  end

  def top_pics
    lim = 5
    # if there's a video, make first pic the thumbnail of video
    if self.video_thumb
      lim = 4
    end
    pics = self.pictures.where.not(attachment_file_size: nil).order('created_at DESC').limit(lim)
    pics
  end

  def likers
    Product.first.likes.first(100).map(&:user)
  end

  def simple_link
    self.link.sub(/^https?\:\/\//, '').sub(/^www./,'').split('/')[0]
  end

  def embed_video
    vid_host = self.video_url.sub(/^https?\:\/\//, '').sub(/^www./,'').split('/')[0]
    if vid_host == 'youtube.com' or vid_host == 'youtu.be'
      youtube_embed(self.video_url)
    elsif vid_host == 'player.vimeo.com' or vid_host == 'vimeo.com'
      vimeo_embed(self.video_url)
    end
  end

  def video_thumb
    vid_host = self.video_url.sub(/^https?\:\/\//, '').sub(/^www./,'').split('/')[0]
    if vid_host == 'youtube.com' or vid_host == 'youtu.be'
      youtube_thumbnail(self.video_url)
    elsif vid_host == 'player.vimeo.com' or vid_host == 'vimeo.com'
      vimeo_thumbnail(self.video_url)
    end
  end

  def youtube_embed(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
      youtube_id = $1
    else
      # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end

    %Q{<iframe title="YouTube video player" width="480" height="360" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe>}
  end

  def vimeo_embed(vimeo_url)
    if vimeo_url[/vimeo\.com\/([^\?]*)/]
      vimeo_id = $1
    else
      vimeo_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      vimeo_id = $5
    end

    %Q{<iframe title="Vimeo video player" width="480" height="360" src="\/\/player.vimeo.com\/video\/#{ vimeo_id }" frameborder="0" allowfullscreen></iframe>}
  end

  def vimeo_thumbnail(vimeo_url)
    if vimeo_url[/vimeo\.com\/([^\?]*)/]
      vimeo_id = $1
    else
      vimeo_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      vimeo_id = $5
    end
    jayson = JSON.parse(open('http://vimeo.com/api/v2/video/' + vimeo_id.to_s + '.json').string)[0]
    jayson["thumbnail_small"]
  end

  def youtube_thumbnail(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
      youtube_id = $1
    else
      # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end
    "http://img.youtube.com/vi/" + youtube_id.to_s + "/0.jpg"
  end

  private

    def get_likes(id, type)
      return Like.where(user_id: self.id, likeable_type: type, likeable_id: id)
    end

    def save_everything
      self.pictures = ImageAsset.where(attachable_id: self.id, attachable_type: "Product")
      self.pictures.each do |asset| 
      	asset.product_id = self.id
        asset.user_id = self.user.id
        asset.save!
      end 
      if !self.pictures.empty?
        self.product_pic = self.pictures.last
      end
      self.feature_groups.each do |f|
      	f.product = self
        f.product_id = self.id
      	f.save!
      end

    end 

    def has_pictures?
    	!self.picture.empty?
    end

    def setup_feature_bounty_content
      feature_groups.build(name: 'singletons', description: 'lorem', singles: true, product_id: self.id)
      bounties.build(question: "What can we do better?")
    end

    def make_create_activity
      Activity.create(timestamp: Time.now, user_id: self.user_id, activity_type: :create, resource_type: :product, resource_id: self.id)
    end
end

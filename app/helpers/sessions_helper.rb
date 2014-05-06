module SessionsHelper
	def sign_in(user, token= nil)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user
		cookies.permanent[:sm_token] = token if token
	end

	def signed_in?
		!current_user.nil?
	end

	def is_admin?
		current_user.admin
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user?(user)
		@current_user == user
	end

	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

  def current_user?(user)
    user == current_user
  end

	def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def rand_pwd 
  	rand(10000000000).to_hex 
  end

  def has_user_image?
  	if signed_in?
   		!current_user.pictures.first.nil?
   	else
   		false
   	end
  end
  
	def process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, :allow_redirections => :safe) do |r|
      r.base_uri.to_s
    end
  end

end

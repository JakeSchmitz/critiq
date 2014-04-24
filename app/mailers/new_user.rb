class NewUser < ActionMailer::Base
  default from: "critiqme@gmail.com"

  def registration_confirmation(user)
  	@user = user
  	mail(to: @user.email, subject: 'Welcome to Critiq!')
  end
end

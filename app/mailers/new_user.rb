class NewUser < ActionMailer::Base
  default from: "jake.schmitz101@gmail.com"

  def registration_confirmation(user)
  	@user = user
  	mail(to: @user.email, subject: 'Welcome to Critiq!')
  end
end

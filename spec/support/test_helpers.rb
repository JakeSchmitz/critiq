module TestHelpers
	include SessionsHelper
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  def login_user
    user = create :user
  	visit signin_path
  	within "form.signin" do 
			fill_in "session_email", with: user.email
			fill_in "session_password", with: user.password
			click_on "SIGN IN"
		end
  end
  
end
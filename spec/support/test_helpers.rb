module TestHelpers

  def login_user
    user = create :user
    User.stubs(:find_by).returns user
  end

  def actual_login_user
    user = create :user
    visit signin_path
    within "form.signin" do 
      fill_in "session_email", with: user.email
      fill_in "session_password", with: user.password
      click_on "SIGN IN"
    end
  end 

  def visit_product_tab(tab)
    login_user
    product = create :product
    visit product_path product
    click_on tab
  end
end
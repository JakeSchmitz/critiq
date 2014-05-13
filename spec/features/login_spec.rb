require 'spec_helper'

describe "Login" do 

	let!(:user) {create :user}

	before :each do 
		visit signin_path
	end

	context "when using valid info" do
		it "logs in" do 
			within "form.signin" do 
				fill_in "session_email", with: user.email
				fill_in "session_password", with: user.password
				click_on "SIGN IN"
			end
			expect(page).to have_content user.name
		end
	end

	context "when using invalid info" do 
		
		it "stays on the signin page" do 
			within "form.signin" do 
				fill_in "session_email", with: user.email
				fill_in "session_password", with: "wrong password"
				click_on "SIGN IN"
			end
			expect(current_path).to eq signin_path
		end
	end
end
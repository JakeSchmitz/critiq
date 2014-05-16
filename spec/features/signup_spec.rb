=begin
Answering Bounties
Creating Bounties
=end

require 'spec_helper'

describe "Signing Up" do 
	
	let(:user) {build :user}

	before :each do 
		visit signup_path
	end

	context "with valid info" do 

		it "signs up a user" do
			within '#new_user' do 
				fill_in "user_name", with: user.name
				fill_in "user_email", with: user.email
				fill_in "user_password", with: user.password
				fill_in "user_password_confirmation", with: user.password_confirmation
				click_on "CREATE ACCOUNT"
			end
			expect(page).to have_content user.name
		end
	end

	context "with invalid info" do 

		it "stays on the signin page" do 
			within '#new_user' do 
				fill_in "user_name", with: user.name
				fill_in "user_email", with: user.email
				fill_in "user_password", with: user.password
				fill_in "user_password_confirmation", with: "not right password"
				click_on "CREATE ACCOUNT"
				expect(current_path).to eq signin_path
			end
		end
	end

end
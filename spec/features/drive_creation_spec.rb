require 'spec_helper' 

describe "Drive Creation" do 

	describe "getting creator access" do 
		before :each do
			actual_login_user 
			visit new_product_path
		end

		it "can not get access to create with incorrect password" do 
			fill_in 'user_creator_code', with: "wrong password"
			click_on "ACCESS"
			expect(current_path).to eq new_product_path
		end

		it "can get access to creator with correct password" do 
			fill_in 'user_creator_code', with: "gimmefeedback"
			click_on "ACCESS"
			expect(page).to have_content "You've just recieved creator permissions"
			expect(page).to have_content "Project Name"
		end
	end

	describe "creating a drive" do 
		let(:product) {build :product}

		before :each do 
			actual_login_user 
			visit new_product_path
			fill_in 'user_creator_code', with: "gimmefeedback"
			click_on "ACCESS"
		end

		it "can create a drive with valid info" do 
			fill_in "product_name", with: product.name
			fill_in "product_description", with: product.description
			fill_in "product_link", with: product.link
			fill_in "product_video_url", with: product.video_url
			click_on "SAVE DRIVE"
			expect(page).to have_content "Drive was successfully created"
			click_link "Finished!"
			expect(page).to have_content product.name
			expect(page).to have_content product.description
		end

		it "does not allow a drive to be created with invalid/empty info" do 
			click_on "SAVE DRIVE"
			expect(current_path).to eq new_product_path
		end
	end
end





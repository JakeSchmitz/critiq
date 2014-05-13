require 'spec_helper'

describe 'Feature Voting', js: true do 

	before :each do 
		login_user
		product = create :product
		@singleton_group = create :feature_group
		@singleton = create :feature
		@comp_group = create :feature_group, singles: false
		@comp_feature = create :feature, feature_group_id: @comp_group.id
		visit product_path product
		click_link 'VOTE'
	end

	describe "Comaprison Features" do 
		it "can be voted on" do 
			sleep(4000)
			click_link "upvoteFeature#{@comp_feature.id}"
			sleep(4000)
			expect(page).to have_content "#{@comp_feature.upvotes} Votes"
		end
	end

	describe "Singletons" do 
	end

end
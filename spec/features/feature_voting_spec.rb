require 'spec_helper'

describe 'Feature Voting', js: true do 

	before :each do 
		login_user
		@product = create :product
		@singleton_group = create :feature_group
		@singleton = create :feature
		@comp_group = create :feature_group, singles: false
		@comp_feature = create :feature, feature_group_id: @comp_group.id
		visit product_path @product
		click_link 'VOTE'
	end

	describe "Comaprison Features" do 
		it "can be voted on with when there is only one option" do 
			click_link "upvoteFeature#{@comp_feature.id}"
			expect(page).to have_content "0 Votes"
		end

		it "can be voted on when there are multiple options" do 
			create :feature, feature_group_id: @comp_group.id
			visit product_path @product
			click_link 'VOTE'
			click_link "upvoteFeature#{@comp_feature.id}"
			expect(page).to have_content "0 Votes"
		end
	end

	describe "Singletons" do 
		it "can be voted on" do 
			find('.thumb-up').click
			expect(page).to have_content @singleton.percent_like.to_i.to_s + "%"
			find('.thumb-down').click
			expect(page).to have_content "0%"
		end
	end
end
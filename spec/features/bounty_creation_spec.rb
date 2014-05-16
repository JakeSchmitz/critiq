require 'spec_helper'

describe 'Bounty Creation' do 
	
	let(:bounty) {build :bounty}

	before :each do
		visit_product_tab "BOUNTIES"
	end

	context "with a newly created product" do 
		it "should have an already created bounty" do 
			expect(page).to have_content "What can we do better?"
		end

		it "can create a new bounty" do  #you should make it modal and redirect straight to the bounties tab
			click_on "Create Bounty"
			fill_in "bounty_question", with: bounty.question
			click_on "Create Bounty" 
			click_on "BOUNTIES"
			expect(page).to have_content bounty.question
		end
	end
end


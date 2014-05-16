require 'spec_helper'

describe 'Bounty Response' do 
	
	let(:comment) {build :bounty_comment}

	before :each do
		visit_product_tab 'BOUNTIES'
	end

	it "can reply to a bounty" do 
		within '.bounty_comment_form' do 
			fill_in 'comment_body', with: comment.body
			click_on 'POST'
			expect(page).to have_content comment.body
		end
	end
end


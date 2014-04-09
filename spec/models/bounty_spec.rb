require 'spec_helper'

describe Bounty do
	it {should belong_to :product}
	it {should have_many :comments}

	before :each do 
		create :bounty
		3.times { create :bounty_comment }
		@bounty = Bounty.first
	end

	it "should be able retrieve its top comments by rating" do
		expect(@bounty.top_responses.first.rating).to eq @bounty.comments.map(&:rating).max
  	end	
end
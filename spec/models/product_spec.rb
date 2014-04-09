require 'spec_helper'

describe Product do 
	it {should belong_to :user}
	it {should have_many :likes}
	it {should have_many :feature_groups}
	it {should have_many :bounties}
	it {should have_many :comments}
	it {should have_one :product_pic}
	it {should have_many :pictures}

	before :each do
		@product = create :product
	end

	it "should be able to determine if it has been liked" do
		@like = create :like, user_id: @product.id, likeable_type: "Product", likeable_id: 1 
		expect(@product.liked? 1, "Product").to be_true
	end

	it "should be able to determine if it has not been likd" do
		expect(@product.liked? 1, "Product").to be_false
	end
end
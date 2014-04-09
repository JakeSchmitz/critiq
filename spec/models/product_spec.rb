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

	context "users" do
		it "can retrieve it's followers" do 
			@product.stubs(:likes).returns [stub(user: "User1")]
			@product.stubs(:feature_groups).returns [stub(features: [stub(likes: [stub(user: "User2")])])]
			expect(@product.followers).to eq ["User1", "User2"]
		end

		it "can retrieve it's top users" do
			user1 = stub swagger: 1
			user2 = stub swagger: 10
			user3 = stub swagger: 5

			@product.stubs(:followers).returns([user1, user2, user3])
			expect(@product.top_users).to eq [user1, user3, user2]
		end
	end
end
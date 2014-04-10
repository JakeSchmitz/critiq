require 'spec_helper'

describe Product do 
	it {should belong_to :user}
	it {should have_many :likes}
	it {should have_many :feature_groups}
	it {should have_many :bounties}
	it {should have_many :comments}
	it {should have_one :product_pic}
	it {should have_many :pictures}

	before :all do
		@product = create :product
	end

	it "should be able to determine if it has been liked" do
		@like = create :like, user_id: @product.id, likeable_type: "Product", likeable_id: 1 
		expect(@product.liked? 1, "Product").to be_true
	end

	it "should be able to determine if it has not been likd" do
		expect(@product.liked? 1, "Product").to be_false
	end

	describe "Users" do
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

	describe "Pictures" do

		context "when it has a profile picture" do 
			it "can retrieve a profile picture" do 
				profile_pic = stub attachment: "picture"
				@product.stubs(:product_pic).returns profile_pic
				expect(@product.profile_pic).to eq profile_pic
			end
		end

		context "when it does not have a profile picture" do 
			it "can retrieve the last picture" do 
				@product.stubs(:product_pic).returns nil
				@product.stubs(:pictures).returns ["picture1", "picture2"]
				expect(@product.profile_pic).to eq "picture2"
			end
		end

		it "can retrieve a random picture" do 
			pictures = (1..10).to_a
			@product.stubs(:pictures).returns pictures
			expect(pictures.include? @product.rand_pic).to be_true
		end
	end

	describe "Features" do 
		context "when the product has a single feature group" do 
			it "retrieves the single feature group" do 
				feature_group = create :feature_group, singles: true
				expect(@product.single_features).to eq feature_group
			end
		end

		context "when the product des not have a single feature group" do 
			it "creates a single feature group" do 
				expect {@product.single_features}.to change {FeatureGroup.count}.by 1
				expect(FeatureGroup.first.singles).to be_true
			end
		end
	end
end
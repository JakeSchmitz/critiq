require 'spec_helper'

describe User do 
	[:products, :comments, :likes, :activities, :pictures].each do |model| 
		it {should have_many model }
	end

	before :all do 
		@user = create :user
	end

	describe "Product metrics" do 

		before :each do 
			10.times {create :product, rating: 10}
			(1..10).to_a.each {|n| create :like, likeable_id: n, likeable_type: "Product"}
		end

		it "has swagger" do 
			expect(@user.swagger).to eq 100
		end

		it "has lovers" do
			expect(@user.lovers).to eq 10
		end
	end

	describe "Profile pictures" do
			before :each do 
			create :image_asset, {user_id: 1}
			create :image_asset, {user_id: 2}
		end

		it "returns its profile pic when it has one" do 
			@user.stubs(:propic_id).returns 1
			expect(@user.profile_pic).to eq ImageAsset.first
		end

		it "returns the last picture when it has no propic_id" do
			@user.stubs(:propic_id).returns nil
			expect(@user.profile_pic).to eq @user.pictures.last
		end

		it "returns the url for the profile picture when the profile picture exists" do 
			@profile_pic = ImageAsset.first
			@user.stubs(:profile_pic).returns stub(attachment: stub(url: "url.com"))
			expect(@user.profile_pic_url).to eq "url.com"
		end	

		it "returns a default picture when there is no profile picture" do
			@user.stubs(:propic_id).returns nil
			expect(@user.profile_pic_url).to eq '/images/missing-user-avatar.png' 
		end
	end
end
require 'spec_helper'

describe Feature do 
	it {should have_many :pictures}
	it {should belong_to :feature_group}
	it {should have_many :likes}

	before :all do 
		@feature = create :feature
	end

	context "retrieving percentage of likes" do
		context "when it has likes" do 
			it "can retrieve the percentage of likes" do
				up_count = rand(1..10)
				down_count = 10 - up_count
				up_count.times { create :like, likeable_type: "Feature", likeable_id: 1}
				down_count.times {create :like, {likeable_type: "Feature", up: false, likeable_id: 1}}
				expect(@feature.percent_like).to eq up_count/(up_count + down_count).to_f
			end
		end

		context "when it has no likes" do
			it "returns 0" do 
				expect(@feature.percent_like).to eq 0
			end
		end
	end

	context "pictures" do 
		before :each do 
			create :image_asset, {feature_id: 1}
			create :image_asset, {feature_id: 2}
		end

		it "returns its profile pic when it has one" do 
			@feature.stubs(:propic_id).returns 1
			expect(@feature.profile_pic).to eq ImageAsset.first
		end

		it "returns the last picture when it has no propic_id" do
			@feature.stubs(:propic_id).returns nil
			expect(@feature.profile_pic).to eq @feature.pictures.last
		end

		it "returns the url for the profile picture when the profile picture exists" do 
			@profile_pic = ImageAsset.first
			@feature.stubs(:profile_pic).returns stub(attachment: stub(url: "url.com"))
			expect(@feature.profile_pic_url).to eq "url.com"
		end	

		it "returns a default picture when there is no profile picture" do
			@feature.stubs(:propic_id).returns nil
			expect(@feature.profile_pic_url).to eq '/images/missing-product.jpg' 
		end

		# it "can save pictures" do 
		# 	@feature.stubs(:feature_group).returns stub(product: stub(user: stub(id: 1), id: 1))
		# 	@feature.stubs(:pictures).returns ImageAsset.all
		# 	@feature.save_pictures
		# 	@pic = ImageAsset.first
		# 	expect(@pic.feature_id).to eq 1
		# 	expect(@pic.user_id).to eq 1
		# 	expect(@pic.product_id).to eq 1
		# end 
	end


end
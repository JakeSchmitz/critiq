require 'spec_helper'

describe Comment do 
	it {should belong_to :user}
	it {should have_many :likes }



	context "when it has a product id" do 
		before :each do
			create :product
			@comment = create :product_comment
		end

		it "can find the product it belongs to" do
			expect(@comment.product).to eq Product.first
		end
	end

	# context "when it does not have a product id" do
	# 	before :each do
	# 		create :feature_group
	# 		@bounty = create :bounty
	# 		@feature = create :feature
	# 		@product = create :product
	# 		@objects = [@bounty, @product, @product]
	# 		@bounty_comment = create :bounty_comment
	# 		@feature_comment = create :feature_comment
	# 		@product_comment = create :product_comment
	# 		@comments = [@bounty_comment, @feature_comment, @product_comment] 
	# 	end
	# end

	context "when it is a product comment" do

		it "returns its path" do 
			product = create :product
			comment = create :product_comment
			expect(comment.path).to eq [product, comment]
		end
	end

	context "when it is a bounty comment" do

		it "returns its path" do 
			bounty = create :bounty
			product = create :product
			comment = create :bounty_comment
			expect(comment.path).to eq [product, bounty, comment]
		end
	end
end






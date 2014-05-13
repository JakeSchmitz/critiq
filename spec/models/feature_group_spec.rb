require 'spec_helper'

describe FeatureGroup do 
	it {should have_many :features}
	it {should belong_to :product}

	before :all do
		@feature_group = create :feature_group
	end

	# context "user votes" do
	# 	it "returns false when there's no current user" do
	# 		expect(@feature_group.can_user_vote_andy nil).to eq false
	# 	end 

	# 	it "returns false when the user has already upvoted" do 
	# 		@feature_group.stubs(:features).returns [stub(upvotes: stub(includes: true))]
	# 		expect(@feature_group.can_user_vote_andy stub(id: 1)).to eq false
	# 	end

	# 	it "returns false when the user has already downvoted" do 
	# 		@feature_group.stubs(:features).returns [stub(upvotes: stub(includes: false), downvotes: stub(includes: true))]
	# 		expect(@feature_group.can_user_vote_andy stub(id: 1)).to eq false
	# 	end

	# 	it "returns true when the user has not voted" do
	# 		@feature_group.stubs(:features).returns [stub(upvotes: stub(includes: false), downvotes: stub(includes: false))]
	# 		expect(@feature_group.can_user_vote_andy stub(id: 1)).to eq true
	# 	end
	# end
end
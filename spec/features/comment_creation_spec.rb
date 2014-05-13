require 'spec_helper'

describe "Comments" do 
	let(:comment) {build :product_comment}


	before :each do 
		login_user
		@product = create :product
		visit product_path @product
	end

	describe "creating new comments" do 
		
		context "for products" do

			before :each do 
				click_on "CRITIQS"
			end

			it "can create a new comment" do 
				within ".product_comment_form" do
					fill_in "comment_body", with: comment.body
					click_on "POST"
				end
				expect(page).to have_content comment.body
			end
		end

		context "for bounties" do

			before :each do 
				click_on "BOUNTIES"
			end

			it "can create a new comment" do 
				within ".bounty_comment_form" do
					fill_in "comment_body", with: comment.body
					click_on "POST"
				end
				expect(page).to have_content comment.body
			end
		end
	end

	describe "replying to comments" do 
		
		context "with a newly created comment" do 
			
			it "can be replied to" do 
				click_on "CRITIQS"
				within ".product_comment_form" do
					fill_in "comment_body", with: comment.body
					click_on "POST"
				end
				click_link "Reply"
				within '#comment-reply' do 
					fill_in "reply-body", with: "reply to comment"
					click_on "Reply"
				end
				expect(page).to have_content("reply to comment")
			end
		end

		context "with an existing comment" do 
			before :each do
				p Product.all
				puts "\n" * 10 
				@comment = create :product_comment
				visit product_path @product
				click_on "CRITIQS"
			end

			it "can be replied to " do 
				click_link "Reply"
				within '#comment-reply' do 
					fill_in "reply-body", with: "reply to comment"
					click_on "Reply"
				end
				expect(page).to have_content("reply to comment")
			end

			it "can be deleted" do 
				click_link "Delete"
				expect(page).to have_content("Deleted")
			end

			# it "can be voted on", js: true do 
			# 	["commentUpvote#{@comment.id}", "commentDownvote#{@comment.id}"].each do |vote|
			# 		2.times do 
			# 			click_on vote
			# 			expect(page).to have_content @comment.rating
			# 		end 
			# 	end
			# end
			# passes only when js: is set to true

		end
	end
end
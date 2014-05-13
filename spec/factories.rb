FactoryGirl.define do
	factory :bounty do
		sequence(:question) { |n| "question #{n}"}
		sequence(:response_count) {|n| n}
		product_id {1}
	end

	factory :bounty_comment, class: "Comment" do
		association :commentable, factory: :bounty
		sequence(:body) {|n| "text" * rand(100) + "#{n}"}
		user_id {1}
		commentable_id {1}
		commentable_type {"Bounty"}
		sequence(:rating) {|n| n * -1 + 1000 }
	end

	factory :feature_comment, class: "Comment" do
		association :commentable, factory: :feature
		sequence(:body) {|n| "text" * rand(100) + "#{n}"}
		user_id {1}
		commentable_id {1}
		commentable_type {"Feature"}
		sequence(:rating) {|n| n * -1 + 1000 }
	end

	factory :product_comment, class: "Comment" do
		association :commentable, factory: :product
		sequence(:body) {|n| "text" * rand(100) + "#{n}"}
		user_id {1}
		product_id {1}
		commentable_id {1}
		commentable_type {"Product"}
	end

	factory :product do
		name {"name"}
		image {"image"}
		description {"text " * 100}
		user_id {1}
		link {"www.product.com"}
		video_url {"wwww.product-video.com"}
		
	end

	factory :feature do
		name {"name"}
		description {"text " * 100}
		product_id {1}
		feature_group_id {1}
	end

	factory :feature_group do
		name {"name"}
		description {"text " * 50}
		product_id {1}
		singles {true}
	end

	factory :like do
		user_id {1}
	end

	factory :image_asset do
		attachment_file_name {"name"}
		user_id {1}
	end

	factory :user do 
		name {"Test-Name"}
		sequence(:email) { |n| "test#{n}@example.com"}
		bio {"random words" * 10}
		password {"asdfasdf"}
		password_confirmation {"asdfasdf"}
	end

end
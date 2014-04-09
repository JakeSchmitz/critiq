FactoryGirl.define do
	factory :bounty do
		sequence(:question) { |n| "question #{n}"}
		sequence(:response_count) {|n| n}
		sequence(:product_id) {|n| n}
	end

	factory :bounty_comment, class: "Comment" do
		association :commentable, factory: :bounty
		sequence(:body) {|n| "text" * rand(100) + "#{n}"}
		user_id {1}
		product_id {1}
		commentable_id {1}
		commentable_type {"Bounty"}
		sequence(:rating) {|n| n * -1 + 1000 }
	end



#   #EXAMPLES
#   # factory :appointment do
#   #   sequence(:title) { |n| "appttitle#{n}" }
#   #   sequence(:description) { |n| "apptdescription#{n}" }
#   #   date        { Date.tomorrow }
#   #   start_time  { Time.now }
#   #   end_time    { Time.now + (60 * 60)}
#   #   user
#   # end
#   # factory :user do
#   #   sequence(:name) { |n| "Andy#{n}" }
#   #   sequence(:email) { |n| "Andy#{n}@example.com" }
#   #   password_hash BCrypt::Password.create "password"
#   # end
#   # factory :payment_profile do
#   #   access_token "some_at"
#   #   publishable_key "some_pk"
#   #   user
#   # end
#   # factory :contact do
#   #   sequence(:first_name) { |n| "Kevin#{n}" }
#   #   sequence(:last_name) { |n| "Awesome#{n}" }
#   #   sequence(:address) { |n| "#{n} Main Street, Berkeley, CA" }
#   #   phone     { '111-111-1111' }
#   #   sequence(:email) { |n| "Kevin#{n}@example.com" }
#   #   user
#   # end
end
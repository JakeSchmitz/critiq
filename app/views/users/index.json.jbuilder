json.array!(@users) do |user|
  json.extract! user, :name, :age, :link
  json.url user_url(user, format: :json)
end

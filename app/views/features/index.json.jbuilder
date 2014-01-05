json.array!(@features) do |feature|
  json.extract! feature, :name, :description, :upvotes, :downvotes
  json.url feature_url(feature, format: :json)
end

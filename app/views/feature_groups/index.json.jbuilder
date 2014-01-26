json.array!(@feature_groups) do |feature_group|
  json.extract! feature_group, :id, :name
  json.url feature_group_url(feature_group, format: :json)
end

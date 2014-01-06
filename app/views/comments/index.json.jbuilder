json.array!(@comments) do |comment|
  json.extract! comment, :id, :title, :body
  json.url comment_url(comment, format: :json)
end

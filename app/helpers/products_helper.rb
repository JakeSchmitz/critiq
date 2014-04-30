module ProductsHelper
  def has_features?
  	set_product
    !@product.features.empty?
  end

  def product_like_url
  	url = request.original_url
  	url.gsub!(":", "%3A")
  	url.gsub!("/", "%2F")
  	url
  end
end

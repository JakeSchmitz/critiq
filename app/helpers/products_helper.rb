module ProductsHelper
  def has_features?
  	set_product
    !@product.features.empty?
  end

end

class PagesController < ApplicationController
	def home
		@products = Product.all
    @top_products = @products.order("rating desc").limit(8)
	end

	def about
	end

	def contact
	end
end

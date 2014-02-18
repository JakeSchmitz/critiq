class PagesController < ApplicationController
	def home
		@products = Product.all
    @top_products = @products.where(:active => true).order("rating desc").limit(10)
    @top_users = User.all.order("created_at asc").limit(5)
	end

	def about
	end

	def contact
	end
end

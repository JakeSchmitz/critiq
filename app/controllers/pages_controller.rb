class PagesController < ApplicationController
	def home
		@products = Product.all
    @top_products = @products.where(:active => true).order("rating desc").paginate(per_page: 4, page: params[:page])
    @top_users = User.all.sort_by{|a| a.swagger}.first(4)
	end

	def about
	end

	def contact
	end

	def login
	end
end

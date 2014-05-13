class PagesController < ApplicationController
	def home
		@products = Product.all
    @top_products = @products.where(:active => true, :hidden => false).order("rating desc").paginate(per_page: 4, page: params[:page])
    @top_users = User.all.sort_by{|a| a.swagger}.first(4)
	end

	def about
	end

	def community
	end

	def contact
	end

	def login
	end

	def how_to

	end

	def terms

	end

	def privacy 

	end
end

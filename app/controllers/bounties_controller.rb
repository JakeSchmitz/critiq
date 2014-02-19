class BountiesController < ApplicationController

	def new
		@product = Product.find(params[:product_id])
		@bounty = @product.bounties.build
	end

	def update 

	end

	def create
		@product = Product.find(params[:product_id])
		if signed_in? and @product.user.id == current_user.id
			@bounty = @product.bounties.new(bounty_params)
			@bounty.product = @product
			@bounty.save 
		end
		redirect_to @product
	end

	def show 
		@product = Product.find(params[:product_id])
		@bounty = Bounty.find(params[:bounty_id])
		@responses = @bounty.comments.order('rating DESC')
	end

	private 

		def bounty_params
			params.require(:bounty).permit(:question, :product_id, :product, :comment)
		end
end

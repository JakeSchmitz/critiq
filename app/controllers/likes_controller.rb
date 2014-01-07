class LikesController < ApplicationController
	def create 
		if signed_in?
			@like = Like.new(like_params)
			@like.user_id = current_user.id
			@like.product_id = params[:product_id]
			@product = Product.find(params[:product_id])
			respond_to do |format| 
				if @like.save!
					format.html { redirect_to @product, notice: 'Product was liked'}
					format.json { head :no_content }
				else
					format.html { redirect_to @product, notice: 'Product couldn\'t be liked' }
        	format.json { head :no_content }
				end
			end
		end
	end

	private
		def like_params
      params.require(:like).permit(:id, :product_id, :user_id)
    end
end

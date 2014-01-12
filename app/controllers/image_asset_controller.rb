class ImageAssetsController < ApplicationController

	before_filter :load_attachable

	def create
		# @image_asset = @attachable.pictures.build(params[:image_asset])
    @image_asset = ImageAsset.new(image_assets_params)
		@image_asset.save
		respond_with @image_asset
	end

	def update
    @asset = @attachable.pictures.find(params[:id])
    if @asset.update_attributes(params[:image_asset])
      redirect_to @attachable, notice: 'Asset was successfully updated.'
    else
      render action: "edit"
    end
	end

	def show
    @image_asset = @attachable.pictures.find(params[:id])
    # do security check here
    send_file @image_asset.data.url(:medium)
	end

  def destroy
    @asset = @attachable.assets.find(params[:id])
    @asset.destroy
    redirect_to @attachable
  end

  def load_attachable
    resource, id = request.path.split('/')[1, 2]
    @attachable  = resource.singularize.classify.constantize.find(id)
  end	

	private

	def image_assets_params
		params.require(:image_asset).permit(:title, :user_id, :id, :image_asset, :pictures_attributes, :attachment_attributes, :attachment => [:tempfile, :original_filename, :content_type, :headers])
	end

end

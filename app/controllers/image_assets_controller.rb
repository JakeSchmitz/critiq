class ImageAssetsController < ApplicationController

	before_filter :load_attachable

	def create
		# @image_asset = @attachable.pictures.build(params[:image_asset])
    @image_asset = ImageAsset.new(image_assets_params)
    respond_to do |format|
		  if @image_asset.save
        format.html {
          render :json => [@image_asset.to_jq_upload],
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: {files: [@image_asset.to_jq_upload]}, status: :created, location: @image_asset}
      else
        format.html { render action: "new" }
        format.json { render json: @image_asset.errors, status: :unprocessable_entity }
      end
    end
	end

  def new
    @image_asset = ImageAsset.new(image_assets_params)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image_asset }
    end
  end

  # GET /uploads/1/edit
  def edit
    @image_asset = ImageAsset.find(params[:id])
  end

	def update
    @image_asset = ImageAsset.find(params[:id])
    respond_to do |format|
      if @image_asset.update_attributes(params[:attachment])
        format.html { redirect_to @image_asset, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @image_asset.errors, status: :unprocessable_entity }
      end
    end
	end

	def show
    @image_asset = @attachable.pictures.find(params[:id])
    # do security check here
    send_file @image_asset.data.url(:medium)
	end

  def destroy
    @asset = @attachable.pictures.find(params[:id])
    @asset.destroy
    redirect_to @attachable
  end

  def load_attachable
    resource, id = request.path.split('/')[1, 2]
    @attachable  = resource.singularize.classify.constantize.find(id)
  end	

	private

	def image_assets_params
		params.permit(:title, :product_id, :user_id, :id, :image_asset, :pictures_attributes, :attachment_attributes, :attachment => [:tempfile, :original_filename, :content_type, :headers])
	end

end

class AddAttachableIdToImageAsset < ActiveRecord::Migration
  def change
    add_column :image_assets, :attachable_id, :integer
  end
end

class AddAttachableTypeToImageAsset < ActiveRecord::Migration
  def change
    add_column :image_assets, :attachable_type, :string
  end
end

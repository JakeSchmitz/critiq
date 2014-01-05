class AddProductIdToImageAssets < ActiveRecord::Migration
  def change
    add_column :image_assets, :product_id, :integer, :default => -1
  end
end

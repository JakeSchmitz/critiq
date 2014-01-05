class AddFeatureIdToImageAsset < ActiveRecord::Migration
  def change
    add_column :image_assets, :feature_id, :integer, :default => -1
  end
end

class AddUserIdToImageAsset < ActiveRecord::Migration
  def change
    add_column :image_assets, :user_id, :integer
  end
end

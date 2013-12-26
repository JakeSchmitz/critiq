class AddUserIdToUserImageAsset < ActiveRecord::Migration
  def change
    add_column :user_image_assets, :user_id, :integer
  end
end

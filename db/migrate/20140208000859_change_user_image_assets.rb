class ChangeUserImageAssets < ActiveRecord::Migration
  def change
  	drop_table :user_image_assets
  end
end

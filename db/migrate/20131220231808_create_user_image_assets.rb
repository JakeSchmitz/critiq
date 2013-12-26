class CreateUserImageAssets < ActiveRecord::Migration
  def change
    create_table :user_image_assets do |t|

      t.timestamps
    end
  end
end

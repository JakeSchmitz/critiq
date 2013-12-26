class CreateImageAssets < ActiveRecord::Migration
  def change
    create_table :image_assets do |t|

      t.timestamps
    end
  end
end

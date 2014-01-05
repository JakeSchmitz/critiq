class AddProductIdToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :product_id, :integer
  end
end

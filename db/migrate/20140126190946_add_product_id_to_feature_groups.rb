class AddProductIdToFeatureGroups < ActiveRecord::Migration
  def change
    add_column :feature_groups, :product_id, :integer
  end
end

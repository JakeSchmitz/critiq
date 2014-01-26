class AddFeatureGroupIdToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :feature_group_id, :integer
  end
end

class AddSinglesToFeatureGroups < ActiveRecord::Migration
  def change
    add_column :feature_groups, :singles, :boolean, :default => false
  end
end

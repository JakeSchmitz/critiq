class CreateFeatureGroups < ActiveRecord::Migration
  def change
    create_table :feature_groups do |t|
      t.string :name
      t.text :description
      t.integer :product_id
      t.timestamps
    end
  end
end

class AddActiveToProducts < ActiveRecord::Migration
  def change
    add_column :products, :active, :boolean, :default => true
  end
end

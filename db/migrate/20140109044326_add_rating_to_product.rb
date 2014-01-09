class AddRatingToProduct < ActiveRecord::Migration
  def change
    add_column :products, :rating, :integer, :default => 0
  end
end

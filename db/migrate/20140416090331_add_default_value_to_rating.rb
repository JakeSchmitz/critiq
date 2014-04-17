class AddDefaultValueToRating < ActiveRecord::Migration
  def change
  	change_column :products, :rating, :integer, :default => 0
  end
end

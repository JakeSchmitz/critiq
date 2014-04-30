class ChangeColumn < ActiveRecord::Migration
  def change
  	change_column :products, :description, :text, :limit => 1000
  end
end

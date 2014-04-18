class AddPasswordToProducts < ActiveRecord::Migration
  def change
    add_column :products, :password, :string
  end
end

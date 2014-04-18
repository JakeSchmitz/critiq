class AddAccessListToProducts < ActiveRecord::Migration
  def change
    add_column :products, :access_list, :text, default: ''
    add_column :products, :hidden, :boolean, default: false
  end
end

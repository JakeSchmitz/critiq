class AddLinkToProducts < ActiveRecord::Migration
  def change
    add_column :products, :link, :string, default: nil
  end
end

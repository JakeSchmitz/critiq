class AddProductIdToBounties < ActiveRecord::Migration
  def change
    add_column :bounties, :product_id, :integer
  end
end

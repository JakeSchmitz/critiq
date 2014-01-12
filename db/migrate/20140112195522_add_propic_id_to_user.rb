class AddPropicIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :propic_id, :integer, :default => nil
  end
end

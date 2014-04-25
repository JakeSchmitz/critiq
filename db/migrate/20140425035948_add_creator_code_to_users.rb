class AddCreatorCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :creator_code, :string
  end
end

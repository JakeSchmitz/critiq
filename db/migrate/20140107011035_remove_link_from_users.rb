class RemoveLinkFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :link
  	remove_column :users, :age
  	remove_column :users, :username
  end
end

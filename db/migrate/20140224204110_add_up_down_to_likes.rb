class AddUpDownToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :up, :boolean, default: true
  end
end

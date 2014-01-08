class AddLikeableStuffToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :likeable_type, :string
    add_column :likes, :likeable_id, :integer
  end
end

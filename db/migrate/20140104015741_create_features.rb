class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.text :description
      t.integer :upvotes
      t.integer :downvotes

      t.timestamps
    end
  end
end

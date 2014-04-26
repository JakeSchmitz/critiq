class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :image
      t.text :description, limit: 1000

      t.timestamps
    end
  end
end

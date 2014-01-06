class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :title
      t.text :body

      t.timestamps
    end
  end
end

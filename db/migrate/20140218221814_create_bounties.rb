class CreateBounties < ActiveRecord::Migration
  def change
    create_table :bounties do |t|
      t.text :question
      t.integer :response_count, :default => 0
      t.timestamps
    end
  end
end

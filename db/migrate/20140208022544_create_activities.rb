class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
    	t.belongs_to :user
    	t.string :activity_type
      t.timestamps
    end
  end
end

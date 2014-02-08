class AddTimestampToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :timestamp, :datetime
  end
end

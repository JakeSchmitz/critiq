class AddResourceToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :resource_type, :string
    add_column :activities, :resource_id, :integer
  end
end

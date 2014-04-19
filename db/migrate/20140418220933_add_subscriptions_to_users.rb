class AddSubscriptionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :critiq_subscription, :boolean, default: true
    add_column :users, :drive_subscription, :boolean, default: true
  end
end

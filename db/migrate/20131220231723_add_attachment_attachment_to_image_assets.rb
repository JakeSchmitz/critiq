class AddAttachmentAttachmentToImageAssets < ActiveRecord::Migration
  def self.up
    change_table :image_assets do |t|
      t.attachment :attachment
    end
  end

  def self.down
    drop_attached_file :image_assets, :attachment
  end
end

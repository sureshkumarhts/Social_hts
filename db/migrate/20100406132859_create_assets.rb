class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.column :group_id,    :integer
      t.column :asset_file_name, :string
      t.column :photo_content_type, :string
      t.column :photo_file_size, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end

class CreateFolders < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
       t.column 'name', :string
      t.column 'date_modified', :datetime
      t.column 'user_id', :integer, :default => 0
      t.column 'parent_id', :integer, :default => 0
      t.column 'is_root', :boolean, :default => false

      t.timestamps
   end
    add_index :folders, :name
    add_index :folders, :date_modified
    add_index :folders, :user_id
    add_index :folders, :parent_id
    add_index :folders, :is_root
  end

  def self.down
    drop_table :folders
  end
end

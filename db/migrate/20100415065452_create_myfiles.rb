class CreateMyfiles < ActiveRecord::Migration
  def self.up
    create_table :myfiles do |t|
      t.column 'filename', :string
      t.column 'description', :string, :default => ""
      t.column 'filesize', :integer
      t.column 'date_modified', :datetime
      t.column 'folder_id', :integer, :default => 0
      t.column 'user_id', :integer, :default => 0
      t.timestamps
    end
         add_index :myfiles, :filename
         add_index :myfiles, :filesize
         add_index :myfiles, :date_modified
         add_index :myfiles, :folder_id
         add_index :myfiles, :user_id
  end



  def self.down
    drop_table :myfiles
  end
end

class CreateTabs < ActiveRecord::Migration
  def self.up
    create_table :tabs do |t|
      t.column :name, :string
      t.column :enable, :boolean, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :tabs
  end
end

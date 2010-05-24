class TabsUsers < ActiveRecord::Migration
  def self.up
    create_table :tabs_users, :id => false, :force => true do |t|
            t.integer :user_id
            t.integer :tab_id
            t.timestamps
        end

  end

  def self.down
     drop_table :tabs_users

  end
end

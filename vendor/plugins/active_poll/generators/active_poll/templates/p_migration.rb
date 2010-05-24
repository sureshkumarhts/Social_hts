class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= questions_table_name %> do |t|
      t.column "name",     :string
      t.column "description", :string
      t.column "multiple",   :boolean
      t.column "max_multiple",   :integer
      t.column "start_date",   :datetime
      t.column "end_date",   :datetime
      t.column "target",   :integer
    end
    create_table :<%= answers_table_name %> do |t|
      t.column "description", :string
      t.column "<%= questions_table_name.singularize %>_id",   :integer
      t.column "votes",    :integer, :default => 0
    end
    create_table :<%= user_answers_table_name %> do |t|
      t.column "user_id", :integer
      t.column "<%= answers_table_name.singularize %>_id",   :integer
    end
  end

  def self.down
    drop_table :<%= questions_table_name %>
    drop_table :<%= answers_table_name %>
    drop_table :<%= user_answers_table_name %>
  end
end

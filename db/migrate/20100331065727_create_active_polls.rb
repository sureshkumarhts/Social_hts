class CreateActivePolls < ActiveRecord::Migration
  def self.up
    create_table :active_poll_questions do |t|
      t.column "name",     :string
      t.column "description", :string
      t.column "multiple",   :boolean
      t.column "max_multiple",   :integer
      t.column "start_date",   :datetime
      t.column "end_date",   :datetime
      t.column "target",   :integer
    end
    create_table :active_poll_answers do |t|
      t.column "description", :string
      t.column "active_poll_question_id",   :integer
      t.column "votes",    :integer, :default => 0
    end
    create_table :active_poll_user_answers do |t|
      t.column "user_id", :integer
      t.column "active_poll_answer_id",   :integer
    end
  end

  def self.down
    drop_table :active_poll_questions
    drop_table :active_poll_answers
    drop_table :active_poll_user_answers
  end
end

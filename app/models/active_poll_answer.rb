class ActivePollAnswer < ActiveRecord::Base
  belongs_to :active_poll_question
end

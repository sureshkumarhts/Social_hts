class ActivePollQuestion < ActiveRecord::Base
  has_many :active_poll_answers
end

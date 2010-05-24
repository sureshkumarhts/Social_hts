require 'acts_as_vote_handler'
ActionController::Base.send :include, ActivePoll::Acts::VoteHandler
ActionView::Base.send :include, ActivePollHelper



module ActivePoll
  public
    # Save the vote, render an answer
    def ap_vote_registered
      poll_name    = params[:poll_name]
      answer_ids = params[:active_poll_answer]
      in_place     = params[:in_place]
      redirect     = params[:redirect]
      view_dir     = get_view_dir(params[:view_dir])
      #change to today.now - question.start_day
      expire_time = 1.year.from_now 
      #find user model from session
      poll = ActivePollQuestion.find_by_name(poll_name)
      user_id = self.respond_to?(:current_user_id)  ? current_user_id : session[:user_id]
      unless user_id.blank?
        user = User.find(user_id) unless user_id.blank?
      else
        salt = poll_name
        cookies["active_poll_#{salt}"] = {:value => "1", :expires => 1.years.from_now, :path => "/" }
      end
    
      if poll_name.nil?
        render :file => "#{view_dir}/error.rhtml"
      elsif answer_ids.nil?
        render :file => "#{view_dir}/no_vote.rhtml"
      elsif maximum_votes_exceeded(poll, answer_ids)
        render :file => "#{view_dir}/max_votes_exceeded.rhtml"
      else
      
        # register the vote
        ActivePollAnswer.transaction do
          answers = ActivePollAnswer.find answer_ids
          answers.each {
            |answer|
            answer.increment! :votes
            user_answer = ActivePollUserAnswer.new
            user_answer.user = user if poll.target == ActivePollHelper::TARGET_LOGGED_USER || poll.target == ActivePollHelper::TARGET_BOTH && !user_id.blank?
            user_answer.active_poll_answer = answer
            user_answer.save!
          }
        end
        
        # remember this poll as the latest poll voted at
        # to help show results
        session[:last_poll] = poll_name
        
        # render in-place or redirect
        if !in_place.nil? and in_place=="true"
    render :file => "#{view_dir}/after_vote.rhtml",
                 :locals => { :poll_name => params[:poll_name], :expire_time =>  expire_time}
        else
    logger.info "redirect to #{redirect}"
    redirect_to redirect
        end
      end
    end  
    
  module Acts
    module VoteHandler
      def self.included(base) 
        base.extend ClassMethods
      end 
      module ClassMethods
        def acts_as_vote_handler(options = {})
          include ActivePoll::Acts::VoteHandler::InstanceMethods    
          extend ActivePoll::Acts::VoteHandler::SingletonMethods        
        end
      end
      # Istance methods
      module InstanceMethods 
        include ActivePoll
      end        
      # Class methods
      module SingletonMethods
      end     
    end #VoteHandler
  end #Acts
   
  private
  def get_view_dir(view_dir_param)
    view_dir_param.blank? ? "#{RAILS_ROOT}/vendor/plugins/active_poll/views" : "#{RAILS_ROOT}/app/views/#{view_dir_param}"
  end

  def maximum_votes_exceeded(poll, answer_ids)
    !poll.max_multiple.blank? && answer_ids.length > poll.max_multiple
  end
end# ActivePoll v1.0

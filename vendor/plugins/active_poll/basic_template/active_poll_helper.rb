module ActivePollHelper
  TARGET_LOGGED_USER = 1
  TARGET_ANONYMOUS = 2
  TARGET_BOTH = 3
  
  # Render the poll
  def active_poll(name, opthash)
    view_dir = get_view_dir(opthash[:view_dir])
    cookie_name = "active_poll_#{name}"
    already_cookie = cookies[cookie_name]
    poll = ActivePollQuestion.find_by_name(name)
    #Check for poll existance
    if poll.blank?
      render :file => "#{view_dir}/poll_not_found.rhtml"
    else
      #poll exists confirmed
      #Now, check user existance
      xxUSER_MODELxx_id = self.respond_to?(:current_user_id)  ? current_user_id : session[:xxUSER_MODELxx_id]
      unless xxUSER_MODELxx_id.blank? && poll.target == TARGET_LOGGED_USER
        logged_user_has_voted = false || user_has_voted_poll?(poll, xxUSER_MODELxx_id) unless xxUSER_MODELxx_id.blank?
        #Ask if the conditions are met to show the poll
        if user_can_see_poll?(poll, xxUSER_MODELxx_id)
          cookie_voted = (already_cookie == "1")
          now=Time.now
          if !user_logged? && cookie_voted
            render :file => "#{view_dir}/already_voted.rhtml", :use_full_path => false
          elsif user_logged? && logged_user_has_voted
            render :file => "#{view_dir}/already_voted.rhtml", :use_full_path => false
          elsif (!poll.start_date.blank? && poll.start_date > now || !poll.end_date.blank? && poll.end_date < now)
            render :file => "#{view_dir}/poll_outdated.rhtml", :use_full_path => false
          else
            question = poll.description
              answers = poll.active_poll_answers
              render :file => "#{view_dir}/show_poll.rhtml", :use_full_path => false,
                :locals => { :question => poll, :answers => answers, :poll_name => name,
                             :in_place => opthash[:in_place], :redirect => opthash[:redirect] , :view_dir => view_dir}        
          end
        end
      else
       #No user found in session & poll configured JUST for USERs (Not anonymous)
       render :file => "#{view_dir}/user_not_logged.rhtml", :use_full_path => false
      end
    end
  end
  
  # Renders the poll results
  def active_poll_results(opthash = { } )
    
    poll_name = opthash[:poll_name] or poll_name = session[:last_poll]
    view_dir = get_view_dir(opthash[:view_dir])
    poll_question = ActivePollQuestion.find(:first, ["name = ? ", poll_name])
   
    unless poll_question.blank?
      question = poll_question.description
      answers = poll_question.active_poll_answers
      votes_total = 0; 
      answers.each { |a| votes_total += a.votes }
      render :file => "#{view_dir}/show_results.rhtml", :use_full_path => false,
	     :locals => { :question => question, :answers => answers, :poll_name => poll_name, :votes_total => votes_total}
    else
      render :file => "#{view_dir}/poll_not_found.rhtml"
    end
  end
  
  private
  
  def user_logged?
    !session[:xxUSER_MODELxx_id].blank?
  end
  
  def check_votes_for_logged_user?(poll)
    poll.target == ActivePollHelper::TARGET_LOGGED_USER || poll.target == ActivePollHelper::TARGET_BOTH && user_logged?    
  end
  
  def user_has_voted_poll?(poll, xxUSER_MODELxx_id)
    result=nil
    unless xxUSER_MODELxx_id.blank?
      result = !(ActivePollUserAnswer.find_by_sql "SELECT active_poll_questions.* FROM active_poll_questions  INNER JOIN active_poll_answers ON active_poll_questions.id = active_poll_answers.active_poll_question_id INNER JOIN active_poll_user_answers ON active_poll_answers.id = active_poll_user_answers.active_poll_answer_id WHERE active_poll_user_answers.xxUSER_MODELxx_id = #{xxUSER_MODELxx_id}" ).blank?
    end
    result
  end
  
  def user_can_see_poll?(poll, user)
    (poll.target == ActivePollHelper::TARGET_LOGGED_USER && !user.blank?) || \
    (poll.target == ActivePollHelper::TARGET_ANONYMOUS && user.blank?) || \
    (poll.target == ActivePollHelper::TARGET_BOTH)  
  end
  
  def get_view_dir(view_dir_param)
    # pwd = app/model => '../../vendor/plugins/active_poll/views' works
    view_dir = "#{RAILS_ROOT}/app/views/#{view_dir_param}" or view_dir = "#{RAILS_ROOT}/vendor/plugins/active_poll/views"
    view_dir
  end
  
end

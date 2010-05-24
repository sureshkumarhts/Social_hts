require 'fileutils'
class ActivePollGenerator < Rails::Generator::Base

  RAILS_ROOT||= File.join(File.dirname(__FILE__), '..', '..', '..')
  ACTIVE_POLL_ROOT = RAILS_ROOT + '/vendor/plugins/active_poll/'
  TEMPLATE_FILES = { 'user_answer_model.rb' => 'generators/active_poll/templates/user_answer_model.rb',  
                         'p_migration.rb' => 'generators/active_poll/templates/p_migration.rb',
                         'acts_as_vote_handler.rb' => 'lib/acts_as_vote_handler.rb',
                         'active_poll_helper.rb' => 'lib/active_poll_helper.rb',
			 'init.rb' => 'init.rb'
  }

  #Define a helper method to repalce text within files and copy the result to a final location
  def replace_and_copy(file_name, model_name, target_dir, output_dir='output', template_dir='basic_template')
    source = File.join(ACTIVE_POLL_ROOT,template_dir,file_name)
    target_file = File.join(ACTIVE_POLL_ROOT,output_dir,file_name)
    File.open(target_file, 'w+') do |fout|
      IO.readlines(source).each do |line|
        fout << line.gsub('xxUSER_MODELxx_cap', model_name.capitalize).gsub('xxUSER_MODELxx', model_name)
      end
    end
    FileUtils.cp(target_file, File.join(ACTIVE_POLL_ROOT,target_dir))
  end

  #Looks for the model
  def model_exists?(model)
    File.exists? File.join(RAILS_ROOT,'app/models', model + '.rb')
  end

  #Tries to use the defualt user model, if it exists.
  def use_default_user_model def_model
    def_model
  end

  def askForUserModel
    temp_folder = 'output' 
    default_model = 'user' 
    template_folder = 'basic_template'
    #Creates a temporary directory
    if(!File.exists?(File.join(ACTIVE_POLL_ROOT,temp_folder)))
      FileUtils.mkdir(File.join(ACTIVE_POLL_ROOT,temp_folder))
    end

    print "\n\nActive_poll Configuration"
    print "\n========================="
    print "\n\nWhich is the user model that you would like to link to the poll's votes ?\n(ENTER will assume 'User' model): "

    find_user_model = nil
    until find_user_model
      user_model = STDIN.gets.chop.downcase
      if model_exists?(user_model) || user_model == ''
        find_user_model = true
        user_model = use_default_user_model default_model if user_model == ''
      else
        print "\n\nUser model not found in your application, please enter a valid user model to assosiate with a poll's vote. \n(ENTER will assume 'User' model): "
      end
    end

    TEMPLATE_FILES.each_pair { |file,destination|
    #Replace user model in file
    replace_and_copy(file, user_model, destination, temp_folder, template_folder)

    #Remove temporary file contents
    FileUtils.rm(File.join(ACTIVE_POLL_ROOT, temp_folder, file))
    }

    #Remove temporary 
    FileUtils.rmdir(File.join(ACTIVE_POLL_ROOT,temp_folder))

    #Print final result
    print "\n\nActive_poll configured."
    print "\nNow you can run scrpt/generate plugin active_poll, in order to finish installation.\n" 
  end

  def manifest
    askForUserModel

    class_path = ''
    
    record do |m|
      
      # Model directory
      m.directory File.join('app/models', class_path)
      
      # Model classes
      m.template 'question_model.rb', File.join('app/models', class_path, "active_poll_question.rb")
      m.template 'answer_model.rb', File.join('app/models', class_path, "active_poll_answer.rb")
      m.template 'user_answer_model.rb', File.join('app/models', class_path, "active_poll_user_answer.rb")
    
      # Migration template
      m.migration_template 'p_migration.rb', 'db/migrate', :assigns => { 
        :migration_name => 'CreateActivePolls',
        :questions_table_name     => 'active_poll_questions',
        :answers_table_name     => 'active_poll_answers',
        :user_answers_table_name     => 'active_poll_user_answers'
      }, :migration_file_name => 'create_active_polls'
    end
  end
  
end

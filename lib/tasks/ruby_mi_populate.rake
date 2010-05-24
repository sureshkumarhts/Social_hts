namespace :railsnet do
  namespace :db do
    desc "Add sample data to the database"
    task :ruby_mi_populate => :environment do
      
      ##########################################################################
      # SETUP, modify this to change how you want to configure your sample data
      NETWORK_NAME = 'RubyMI'
      NUMBER_OF_TEST_USERS = 12
      GROUP_PHOTO_1 = File.new(RAILS_ROOT + "/public/images/rails.png")
      GROUP_PHOTO_2 = File.new(RAILS_ROOT + "/public/images/rails2.png")
      ##########################################################################
      
      # Output configuration
      puts 'Setting up sample data for your EngineY network.'
      puts 'Network Name: ' + NETWORK_NAME
      puts '# of Users: ' + NUMBER_OF_TEST_USERS.to_s
      
      # Start data creation
      puts 'Create network...'
      Network.destroy_all
      Network.create(:name => NETWORK_NAME,
                     :organization => 'Ruby Enthusiasts of Michigan',
                     :website => 'http://www.rubymi.org',
                     :description => 'Welcome to the Ruby Enthusiasts of Michigan website.  This site serves as a hub for all of the Ruby related activities and events that happen in and around Michigan.')
    
      puts 'Populating roles...'
      Role.destroy_all
      ['creator', 
       'administrator', 
       'group_admin',
       'user', 
       'contributor'].each {|r| Role.create(:rolename => r) } 
      
      ##########################################################################
      puts 'Creating users...'
      Activity.destroy_all
      User.destroy_all
      Photo.destroy_all
      state_id = State.find_by_name('MICHIGAN').id
      print '.'
      user1 = User.new :first_name=>'Timothy',
                    :last_name=>'Fisher',
                    :sex=>'M',
                    :state_id=>state_id,
                    :country_id=>1,
                    :zip=>'48134',
                    :login=>'admin', 
                    :email=>'timothyf@gmail.com',
                    :city=>'Flat Rock',
                    :twitter_id=>'tfisher',
                    :facebook_url=>'http://www.facebook.com/trfisher',
                    :activated_at=>'2009-01-01',
                    :password=>'admin',
                    :password_confirmation=>'admin'
      user1.save
      
     photo = ProfilePhoto.create(:is_profile => true, 
                         :temp_path => File.new(RAILS_ROOT + "/public/images/tim.png"), 
                         :filename => 'tim.png', 
                         :content_type => 'image/png',
                         :user => user1)
      user1.profile_photo = photo
      user1.save
      user1.activate
      user1.roles << Role.find_by_rolename('creator')
      print '.'
      user = User.new :first_name=>'John',
                    :last_name=>'Smith',
                    :sex=>'M',
                    :state_id=>state_id,
                    :country_id=>1,
                    :zip=>'48134',
                    :login=>'jsmith', 
                    :email=>'timothyf@gmail.com',
                    :city=>'Flat Rock',
                    :activated_at=>'2009-01-01',
                    :password=>'jsmith',
                    :password_confirmation=>'jsmith'
      user.save
      #user.set_temp_photo()
      #user.save
      user.activate
      user.make_group_admin(1)
      #user.roles << Role.find_by_rolename('user')
      print '.'
      user2 = User.new :first_name=>'Paul',
                    :last_name=>'Edwards',
                    :sex=>'M',
                    :state_id=>state_id,
                    :country_id=>1,
                    :zip=>'48134',
                    :login=>'pedwards', 
                    :email=>'timothyf@gmail.com',
                    :city=>'Flat Rock',
                    :activated_at=>'2009-01-01',
                    :password=>'pedwards',
                    :password_confirmation=>'pedwards'
      user2.save
      #user2.set_temp_photo
      #user2.save
      user2.activate
      #user2.make_group_admin(1)
      
      (1..NUMBER_OF_TEST_USERS).each do |number|
        print '.'
        user3 = User.new :first_name=>"Test#{number}",
                      :last_name=>"User#{number}",
                      :sex=>'M',
                      :state_id=>state_id,
                      :country_id=>1,
                      :zip=>'48134',
                      :login=>"testuser#{number}", 
                      :email=>'timothyf@gmail.com',
                      :city=>'Flat Rock',
                      :activated_at=>'2009-01-01',
                      :password=>'testuser',
                      :password_confirmation=>'testuser'
        user3.save
        #user3.set_temp_photo
        #user3.save
        user3.activate
      end
      puts ''
      
      ##########################################################################
      puts 'Creating friendships...'
      Friendship.destroy_all
      
      # FRIENDS
      @user = User.find(1)
      @friend = User.find(2)
      Friendship.request(@user, @friend)
      
      @user = User.find(2)
      @friend = User.find(1)
      Friendship.accept(@user, @friend)
      
      @user = User.find(1)
      @friend = User.find(3)
      Friendship.request(@user, @friend)
      
      @user = User.find(3)
      @friend = User.find(1)
      Friendship.accept(@user, @friend)
      
      # REQUESTED FRIENDS
      @user = User.find(1)
      @friend = User.find(4)
      Friendship.request(@user, @friend)
      
      @user = User.find(1)
      @friend = User.find(5)
      Friendship.request(@user, @friend)
      
      # PENDING FRIENDS
      @user = User.find(6)
      @friend = User.find(1)
      Friendship.request(@user, @friend)
      
      @user = User.find(6)
      @friend = User.find(1)
      Friendship.request(@user, @friend)
      
      ##########################################################################
      puts 'Creating test groups...'
      Group.destroy_all
      group = Group.new(:name => 'Detroit Ruby User Group',
                        :description => 'The Detroit Ruby User Group.',
                        :creator_id => user1.id,
                        :featured => false)    
     photo = ProfilePhoto.create(:is_profile => true, 
                         :temp_path => GROUP_PHOTO_1, 
                         :filename => 'testgroup.png', 
                         :content_type => 'image/png',
                         :group => group)                         
     group.profile_photo = photo
     group.save
     
      group = Group.new(:name => 'Ann Arbor Ruby Brigade',
                        :description => 'The Ann Arbor Ruby User Group.',
                        :creator_id => user1.id,
                        :featured => false)    
     photo = ProfilePhoto.create(:is_profile => true, 
                         :temp_path => GROUP_PHOTO_2, 
                         :filename => 'testgroup2.png', 
                         :content_type => 'image/png',
                         :group => group)                         
     group.profile_photo = photo
     group.save
     
     puts 'Creating group memberships'
     Membership.destroy_all
     role = Role.find_by_rolename('user')
     (1..NUMBER_OF_TEST_USERS).each do |num|
       Membership.create({:group_id=>1, 
                          :user_id=>num,
                          :role_id=>role.id})
     end
     
     ##########################################################################
     puts 'Creating test Events...'
     Event.destroy_all
     event = Event.new(:name => "Detroit RUG Meeting",
                          :user_id => user1.id,
                          :description => 'DRUG Meeting for April.',
                          :event_type => 'User Group Meeting',
                          :start_time => Time.new,
                          :end_time => Time.new,
                          :location => "Compuware Building",
                          :street => 'One Campus Martius',
                          :city => 'Detroit',
                          :website => 'http://drug.rubymi.org',
                          :phone => '555-555-1212',
                          :organized_by => 'Timothy Fisher')                          
     photo = ProfilePhoto.create(:is_profile => true, 
                         :temp_path => File.new(RAILS_ROOT + "/public/images/testevent.jpg"), 
                         :filename => 'testevent.jpg', 
                         :content_type => 'image/jpg',
                         :event => event)                        
     event.profile_photo = photo
     event.save
     
     event = Event.new(:name => "AnnArbor.rb Meeting",
                          :user_id => user1.id,
                          :description => 'April Meeting for Ann Arbor Ruby Brigade.',
                          :event_type => 'User Group Meeting',
                          :start_time => Time.new,
                          :end_time => Time.new,
                          :location => "Compuware Building",
                          :street => 'One Campus Martius',
                          :city => 'Detroit',
                          :website => 'http://aa.rubymi.org',
                          :phone => '555-555-1212',
                          :organized_by => 'Timothy Fisher')                          
     photo = ProfilePhoto.create(:is_profile => true, 
                         :temp_path => File.new(RAILS_ROOT + "/public/images/testevent.jpg"), 
                         :filename => 'testevent.jpg', 
                         :content_type => 'image/jpg',
                         :event => event)                        
     event.profile_photo = photo
     event.save
     
     ##########################################################################
      puts 'Creating RSS Feed...'
      RssFeed.destroy_all
      RssFeed.create(:name => "Tim's Blog",
                     :url => 'http://feeds.feedburner.com/TimothyFishersBlog',
                     :user => user1)
                     
      ##########################################################################              
      puts 'Creating a message...'
      Message.destroy_all
      Message.create(:subject=>'Test Message',
                     :body=>'This is just a test message',
                     :sender_id=>user.id,
                     :recipient_id=>user1.id)
         
      ##########################################################################
      puts 'Creating Job Postings...'
      JobPost.destroy_all
      JobPost.create(:job_title=>"Software Developer",
                     :company=>"RailsEdge Inc.",
                     :website=>'www.railsedge.com',
                     :contact_name=>'Joe Schmoe',
                     :job_id=>"123456",
                     :email=>"jobs@railsedge.com",
                     :description=>"We are looking for someone with at least 3 years of experience using Ruby and Ruby on Rails. CSS and HTML experience are also desirable.",
                     :featured=>false,
                     :end_date=>nil)  
                     
      JobPost.create(:job_title=>"Development Team Lead",
                     :company=>"RailsEdge Inc.",
                     :website=>'www.railsedge.com',
                     :contact_name=>'Joe Schmoe',
                     :job_id=>"123456",
                     :email=>"jobs@railsedge.com",
                     :description=>"We are looking for an experienced software development team leader for an exciting web application team.  Ideally the leader will have 3-5 years of experience using Ruby and the Ruby on Rails framework.  CSS, HTML, and JavaScript experience is also a plus.",
                     :featured=>false,
                     :end_date=>nil)   
                     
      ##########################################################################
      puts 'Creating Forum Topics...'
      ForumTopic.destroy_all
      ForumTopic.create(:title => 'Ruby',
                        :description => 'Discussion about the Ruby language',
                        :user_id => user1.id)
      ForumTopic.create(:title => 'Rails',
                        :description => 'Discussion about the Ruby on Rails framework',
                        :user_id => user1.id)
      ForumTopic.create(:title => 'Non-Rails Frameworks',
                        :description => 'Discussion about other Ruby frameworks',
                        :user_id => user1.id)
      ForumTopic.create(:title => 'Site Suggestions',
                        :description => 'Have an idea for the RubyMI site?  Contribute ideas and suggestions here.',
                        :user_id => user1.id)
      ForumTopic.create(:title => 'Water Cooler',
                        :description => 'This topic if a free-for-all.  Respect others and share what you wish here.',
                        :user_id => user1.id)
                  
      ##########################################################################
      puts 'Creating Forum Posts...'
      ForumPost.destroy_all
      ForumPost.create(:user => user1,
                       :title => 'A Question about Ruby',
                       :body => 'I have a simple question about Ruby.  What type of language is Ruby???',
                       :parent_id => nil,
                       :forum_topic => ForumTopic.find_by_title('Ruby'),
                       :featured => false)
      ForumPost.create(:user => user2,
                       :title => 'RE: A Question about Ruby',
                       :body => 'Ruby is a dynamically types, scripted programming language.',
                       :parent_id => ForumPost.find(:first).id,
                       :forum_topic => ForumTopic.find_by_title('Ruby'),
                       :featured => false)
      ForumPost.create(:user => user1,
                       :title => 'A Question about Rails',
                       :body => 'I have a simple question about Rails.  What type of framework is Rails??',
                       :parent_id => nil,
                       :forum_topic => ForumTopic.find_by_title('Rails'),
                       :featured => false)
      ForumPost.create(:user => user2,
                       :title => 'RE: A Question about Rails',
                       :body => 'Rails is an MVC web application framework.',
                       :parent_id => ForumPost.find_by_title('A Question about Rails').id,
                       :forum_topic => ForumTopic.find_by_title('Rails'),
                       :featured => false)                
      
      ##########################################################################
      puts 'Creating blog posts...'
      BlogPost.destroy_all
      BlogPost.create(:user => user1,
                      :title => 'Welcome to RubyMI',
                      :body => "This site is being launched as a new community site for anyone who programs in or aspires to program in the Ruby programming language.  This site is not affiliated with a single user group, but provides a single point of contact for you to keep up with what is going on in the Ruby community throughout Michigan.  Here you will find notification of upcoming Ruby related events in Michigan and nearby, a community of like-minded Ruby enthusiasts to network with, and a place to share your knowledge with others.<br/><br/>I hope you enjoy the new RubyMI community site.<br/><br/>Sincerely,<br/>Timothy Fisher",
                      :published => true,
                      :featured => true
                      )      
      (1..NUMBER_OF_TEST_USERS).each do |number|
        BlogPost.create(:user => User.find_by_login("testuser#{number}"),
                        :title => "Post from Test User #{number}",
                        :body => "This site is being launched as a new community site for anyone who programs in or aspires to program in the Ruby programming language.  This site is not affiliated with a single user group, but provides a single point of contact for you to keep up with what is going on in the Ruby community throughout Michigan.  Here you will find notification of upcoming Ruby related events in Michigan and nearby, a community of like-minded Ruby enthusiasts to network with, and a place to share your knowledge with others.<br/><br/>I hope you enjoy the new RubyMI community site.<br/><br/>Sincerely,<br/>Timothy Fisher",
                        :published => true,
                        :featured => false
                        )  
      end
      
      ##########################################################################
      puts 'Creating Photo Albums...'
      PhotoAlbum.create(:title=>'Summer Photos',
                        :description=>'A collection of summer photos.',
                        :user=>user1)
                        
      PhotoAlbum.create(:title=>'Winter Photos',
                        :description=>'A collection of winter photos.',
                        :user=>user1)
                        
      
      ##########################################################################
      # Close File Streams
      puts 'Closing file streams...'
      GROUP_PHOTO_1.close
      GROUP_PHOTO_2.close
      
      ##########################################################################
      # Create Widgets   
      puts 'Creating widgets...'
      Widget.create(:name => 'members_home')
      Widget.create(:name => 'groups_home')
      Widget.create(:name => 'events_home')
      Widget.create(:name => 'announcements_home')
      Widget.create(:name => 'activity_feed_home')
      Widget.create(:name => 'blog_posts_home')
      Widget.create(:name => 'links_home')
      Widget.create(:name => 'projects_home')
      Widget.create(:name => 'job_posts_home')
      Widget.create(:name => 'forum_posts_home')
      Widget.create(:name => 'photos_home')
      Widget.create(:name => 'html_content_home')
      
      Widget.create(:name => 'status_posts_profile')
      Widget.create(:name => 'about_me_profile')
      Widget.create(:name => 'blog_posts_profile')
      Widget.create(:name => 'activity_feed_profile')
      Widget.create(:name => 'links_profile')
      Widget.create(:name => 'projects_profile')

      ##########################################################################
      # Create Pages
      puts 'Creating pages...'
      Page.create(:title => 'home')
      Page.create(:title => 'profile')
      
      ##########################################################################
      # Create Layouts
      puts 'Creating layouts...'
      WidgetLayout.create(:widget_id => 1, :page_id => 1, :col_num => 1)
      WidgetLayout.create(:widget_id => 2, :page_id => 1, :col_num => 1)
      WidgetLayout.create(:widget_id => 3, :page_id => 1, :col_num => 1)
      WidgetLayout.create(:widget_id => 4, :page_id => 1, :col_num => 2)
      WidgetLayout.create(:widget_id => 5, :page_id => 1, :col_num => 2)
      WidgetLayout.create(:widget_id => 6, :page_id => 1, :col_num => 2)
      WidgetLayout.create(:widget_id => 7, :page_id => 1, :col_num => 2)
      WidgetLayout.create(:widget_id => 8, :page_id => 1, :col_num => 2)
      WidgetLayout.create(:widget_id => 9, :page_id => 1, :col_num => 3)
      WidgetLayout.create(:widget_id => 10, :page_id => 1, :col_num => 3)
      WidgetLayout.create(:widget_id => 11, :page_id => 1, :col_num => 3)
      #WidgetLayout.create(:widget_id => 12, :page_id => 1, :col_num => 3)
      
      WidgetLayout.create(:widget_id => 13, :page_id => 2, :col_num => 2)
      WidgetLayout.create(:widget_id => 14, :page_id => 2, :col_num => 2)
      WidgetLayout.create(:widget_id => 15, :page_id => 2, :col_num => 2)
      WidgetLayout.create(:widget_id => 16, :page_id => 2, :col_num => 2)
      WidgetLayout.create(:widget_id => 17, :page_id => 2, :col_num => 3)
      WidgetLayout.create(:widget_id => 18, :page_id => 2, :col_num => 3)
      
      puts 'Database population done!'
    end
  end
end

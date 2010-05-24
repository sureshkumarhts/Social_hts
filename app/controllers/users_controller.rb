class UsersController < ApplicationController
  
  uses_tiny_mce :options => {
    :theme => 'advanced',
    :theme_advanced_toolbar_location => "top",
    :theme_advanced_toolbar_align => "left",
    :theme_advanced_resizing => true,
    :theme_advanced_resize_horizontal => false,
    :theme_advanced_buttons1 => "forecolor,backcolor,bullist,numlist,separator,outdent,indent,separator,undo,redo,separator,link,unlink,anchor,image,cleanup,help,code",
    :theme_advanced_buttons2 => "",
    :theme_advanced_buttons3 => ""
  }
  
  before_filter :login_required, :only => [:edit, :update]

  before_filter :tabs_enable, :only => [:index]
  
  
  # Called from the blog settings of the 'My Blog' widget on a user page
  # this sets an RSS feed URL for mirroring
  def update_blog_feed_url
    url = params[:url]  
    render :partial=>'users/blog_posts_widget', :layout=>false
  end

  
  def grid_data_old
    @users = User.find(:all)
    respond_to do |format|
      format.xml { render :partial => 'users/griddata.xml.builder', :layout=>false }
    end
  end
  
  
  # Returns a list of users in a JSON array.  This is used to display
  # the DOJO grid for the admin page.
  def grid_data
    @users = User.find(:all, :select=>'id, first_name, last_name')
    render :json => @users.to_json
  end
  
  
  # Register all existing users with Facebook
  # Should only be required to run once, afterward all new users will be registered at creation time.
  def fb_register_all_users
    User.find(:all).each do |user|
      user.register_user_to_fb
    end
  end

  
  # Called after a user logs in via Facebook Connect
  def link_facebook_account
    if self.current_user.nil?
      # no local user, so create a new local user account
      # seems like a user who already exists locally, but not yet linked to facebook would also take this path
      #  (unless he was registered to facebook which would set his email hash allowing the login_by_facebook to log
      #   him in)
      if (facebook_session)
        @user = User.new
        @user.facebook_id = facebook_session.user.id
        render :partial => 'facebook_user_form', :layout=>true
      end
    else
      # local user account exists, link the facebook account with local account
      # seems like this path would only be taken when local user is already linked to facebook user
      # could be reached if user already locally logged in connects with facebook
      # of if a user has been registered to facebook, but not connected yet
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.facebook_id == facebook_session.user.id
      redirect_to '/'
    end
  end
  
  
  def promote_to_group_admin
    user_id = params[:user_id]
    group_id = params[:group_id]
    Membership.find_by_user_and_group(user_id, group_id)
  end
  
  
  def demote_from_group_admin
    
  end
  
  
  # Called to show the 'Members' page or the members of a group page
  def index
    @section = 'MEMBERS' 
    if params[:group_id] == nil
      display_members_list_page
    else
      display_group_members_page
    end
  end
  
  
  def display_members_list_page
    puts ""
    sort = params[:sort_field]      
    @sort_field = sort || 'created_at'
    respond_to do |format|
      format.html {
        @users = User.paginate(:all, :page => params[:page], :conditions => "activated_at is not null", 
          :include=>[:profile_photo, :state, :country], :order => @sort_field + ' ASC')
        @user_count = User.cached_count
      }
      format.xml  { 
        @users = get_users_for_api
        render :xml => @users 
      }
      format.json {
        @users = get_users_for_api
        render :json => @users
      }
    end
  end
  
  
  def display_group_members_page 
    @group = Group.find(params[:group_id])
    @users = @group.users
    respond_to do |format|
      format.html { render :template => 'groups/manage_group_users' }
      format.xml  { render :xml => @users.to_xml(:dasherize => false) }
      format.json  { render :json => @users.to_json(:dasherize => false) }
    end
  end
  
  
  def get_users_for_api
    filters = get_filter
    filter_str = build_filter_string(filters) 
    if filter_str.length > 0
      conditions = "activated_at is not null AND " + filter_str
    else
      conditions = "activated_at is not null"
    end
    if params[:limit]
      offset = params[:offset] || 0
      limit = params[:limit] 
      @users = User.find(:all, 
        :select=>get_users_xml_select,
        :conditions => conditions,
        :limit=>limit,
        :offset=>offset,
        :order => @sort_field + ' ASC')
    else
      @users = User.find(:all, 
        :select=>get_users_xml_select,
        :conditions => conditions,
        :order => @sort_field + ' ASC')
    end
    @users
  end
  
  
  def get_filter
    attrs = User.column_names
    filters = []
    params.each {|key,value|
      next if key == 'api_key'
      if attrs.include?(key) 
        filters << key
      end
    }
    filters
  end
  
  
  def build_filter_string(filters) 
    result = ''
    filters.each do |filter|
      result += ' AND ' unless result == ''
      result += filter + "='" + params[filter] + "'" 
    end
    result
  end
  
  
  # Called to display a user page, including the 'My Page' page.
  # Most content loaded onto the page as AJAX widgets
  def show   
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { 
        if (current_user && (current_user.id.to_s == params[:id].to_s))
          @section = 'MY PAGE'
        else 
          @section = 'MEMBERS'
        end
        @page_name = 'profile'
        if @user.twitter_id && @user.display_tweets
          @tweets = @user.fetch_tweets
        end
      }
      format.xml { render :xml => @user.to_xml(:dasherize => false) }
      format.json { render :json => @user.to_json }
    end
  end


  def new
    @invite_code = params[:invite_code]
    @user = User.new
  end

  
  def edit
    if (params[:id].to_s != current_user.id.to_s)
      redirect_back_or_default('/')
    end
    @user = User.find(params[:id])
  end


  def create_facebook_user
    if facebook_session
      User.create_from_fb_connect(facebook_session.user, @user.email, @user.login, @user.first_name, @user.last_name)
      flash[:notice] = "Thanks for signing up!"
    end
    redirect_to '/'
  end


  def create
    @user = User.new(params[:user])
    if @user.facebook_id
      create_facebook_user
    else
      # create just a local user
      sleep 4  # required for photo upload
      cookies.delete :auth_token
      @user.roles << Role.find_by_rolename('user')
      @user.save
      if @user.errors.empty?
        if params[:invite_code]
          Invite.accept(params[:invite_code]) 
        end
        @user.set_photo(params[:user_photo])
        respond_to do |format|
          format.html {
            flash[:notice] = "Thanks for signing up!"
            render :template=>'sessions/signup_thankyou'
          }
          format.xml {
            if !Configuration.REQUIRE_ACTIVATE_FOR_USER_CREATE_VIA_API
              @user.activate
            end
            render :xml => @user, :status => :created, :location => @user
          }
          format.json {
            if !Configuration.REQUIRE_ACTIVATE_FOR_USER_CREATE_VIA_API
              @user.activate
            end
            render :json => @user.to_json, :status => :created, :location => @user
          }
        end
      else
        respond_to do |format|
          format.html {
            render :action => 'new'
          }
          format.xml {
            render :xml => @user.errors, :status => 'failed'
          }
          format.json {
            render :json => @user.errors, :status => 'failed'
          }  
        end
      end
    end
  end
  
  
  def update
    if (params[:id].to_s != current_user.id.to_s)
      redirect_back_or_default('/')
    end
    sleep 4  # required for photo upload
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])        
        if params[:user_photo] && params[:user_photo].size != 0 
          # remove old profile photos
          Photo.destroy_all("user_id = " + @user.id.to_s + " AND is_profile = true")
          profile_photo = ProfilePhoto.create!(:user_id=>@user.id, :is_profile=>true, :uploaded_data => params[:user_photo]) if params[:user_photo].size != 0 
          @user.profile_photo = profile_photo
        end  
        
        flash[:notice] = 'User was successfully updated.'
        format.html { 
          if params['admin_page']
            redirect_to('/admin/users')
          else
            redirect_to(@user) 
          end         
        }
        format.xml  { head :ok }
        format.json { head :ok } 
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end


  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
      render :template=>'users/activate_complete'
    else
      redirect_back_or_default('/')
    end
  end
  
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to('/') } 
      format.xml { head :ok } 
      format.json { head :ok } 
    end
  end
  
  
  private
  def get_users_xml_select
    'id, first_name, last_name, login, sex, city, state_id, zip, country_id, 
    phone, phone2, time_zone, about_me, organization, skills, occupation, featured,
    website, blog, blog_feed, flickr, flickr_username, linked_in_url, twitter_id, aim_name,
    gtalk_name, yahoo_messenger_name, msn_name, youtube_username, skype_name, posts_count,
    last_seen_at, login_count, activated_at, enabled, is_active, identity_url'
  end

end


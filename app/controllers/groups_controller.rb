#   Copyright 2009 Timothy Fisher
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

class GroupsController < ApplicationController
  
  layout "group" 
  
   
  

  acts_as_vote_handler

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

  before_filter :login_required, :only => [:new, :edit, :create, :update,:upload]
  
  # must be a group admin to edit or update a group
  before_filter :check_group_auth, :only => [:edit, :update]
  
  # must be an admin to create new groups
  before_filter :check_admin_auth, :only => [:new, :create,:upload]

  before_filter :tabs_enable, :only => [:index]
  
  
  def user_data
    @group = Group.find(params[:group_id])
    @users = @group.users
    items = []
    @users.each do |user|
      membership = user.memberships.find_by_group_id(@group.id)
      items.push({:id => user.id,
          :name => user.name,
          :email => user.email,
          :role => membership.role.rolename,
          :created_at => membership.created_at})
    end
    result = {}
    result[:identifier] = 'id'
    result['label'] = 'id'
    result['items'] = items
    render :json=>result, :layout=>false
  end
  
  
  def check_admin_auth
    if !current_user.is_admin
      access_denied
    end
  end
  
  
  def check_group_auth
    if !current_user.is_group_admin(Group.find(params[:id]))
      access_denied
    end
  end
  
  
  def index
    sort = params[:sort_field]
    @sort_field = sort || 'created_at'
    @section = 'GROUPS'   
    if params[:user_id]
      @user = User.find(params[:user_id])
      @group = @user.groups
      @groups = Group.find(@group,:order => @sort_field + ' ASC')
    else 
      @groups = Group.find(:all,:order => @sort_field + ' ASC')
    end  
    #respond_to do |format|
    # format.html # index.html.erb
    # format.xml  { render :xml => @groups }
    # format.json { render :json => @groups.to_json }
    #end
    render :layout=> 'application'
  end

  def search
    @params = params[:search]
    if logged_in?
      @user = current_user
      @groups_id = @user.groups
    else
      @groups_id = Group.find(:all, :conditions => ['private =? ', 0])
    end
    @groups = Group.paginate :per_page => 20, :page => params[:page], :conditions => ['groups.name LIKE ? AND id in (?)',@params , @groups_id.collect{|x|x.id}]
    @events = Event.paginate :per_page => 20, :page => params[:page], :include => [ :group], :conditions => ['events.name LIKE ? AND group_id in (?)',@params , @groups_id.collect{|x|x.id}]
    @forums = ForumTopic.paginate :per_page => 20, :page => params[:page], :include => [ :group], :conditions => ['forum_topics.title LIKE ? AND  group_id in (?)',@params , @groups_id.collect{|x|x.id}]
    @wiki = WikiPage.paginate :per_page => 20, :page => params[:page], :include => [ :group], :conditions => ['wiki_pages.title LIKE ? OR wiki_pages.content LIKE ? AND  group_id in (?)',@params ,'%'+@params+'%' , @groups_id.collect{|x|x.id}]
    render :layout=> 'application'
  end


  def wiki_list
    @user = current_user
    @group = Group.find(params[:id])
    @wiki = WikiPage.find(:all, :conditions => ['group_id in (?)', @group.id])
  end

  def events
    if params[:group_id] and !params[:type]
      @group = Group.find(params[:group_id])
    elsif   params[:event_id] and !params[:type]
      @event = Event.find(params[:event_id])
      @group = Group.find(@event.group_id)
    elsif params[:type]
      @group = Group.find(params[:id])
      @event = Event.new
    end
    
  end
  def eventss
    @events = params[:event_id]
  end

  def forums
    if !params[:forum_topic_id] and !params[:forum_post_id]
      @group = Group.find(params[:group_id])
    elsif params[:forum_topic_id] and !params[:forum_post_id]
      @forum_topic = ForumTopic.find(params[:forum_topic_id])
      @forum_posts = @forum_topic.forum_threads
      @group = Group.find(@forum_topic.group_id)
    else
      @forum_post = ForumPost.find(params[:forum_post_id])
      if @forum_post.parent_id != nil
        @forum_post = ForumPost.find(@forum_post.parent_id)
      end
      @forum_post.update_attributes(:views=>@forum_post.views+1)
      @group = Group.find(@forum_post.forum_topic.group_id)
    end
  end


  def group_members
    @group = Group.find(params[:group_id])
    @members = Membership.find(:all, :conditions => ['approved =? and group_id =?', 1,@group.id ])
  end

  def group_others
    @group = Group.find(params[:group_id])
  end

    def group_admin
    @group = Group.find(params[:group_id])
  end



  def show
    @group = Group.find(params[:id])
    #self.id = @group
    @members = Membership.find(:all, :conditions => ['approved =? and group_id =?', 1,@group.id ])
    if @group
      @@ID = @group
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @group }
        format.json { render :json => @group } 
      end
    else
      respond_to do |format|
        format.xml { render :status => :unprocessable_entity } 
        format.json { render :status => :unprocessable_entity } 
      end
    end
  end


  def new
    @group = Group.new
     render :layout=> 'application'
  end


  def edit
    @group = Group.find(params[:id])
    @show_full = true
  end


  def create
    sleep 4  # required for photo upload
    @group = Group.new(params[:group])
    @group.creator = current_user;
    respond_to do |format|
      if @group.save
        if params[:group_photo] 
          # save group photo
          @group.profile_photo = ProfilePhoto.create!(:is_profile=>true, :uploaded_data => params[:group_photo]) if params[:group_photo].size != 0 
        end               
        flash[:notice] = 'Group was successfully created.'
        format.html { 
          if params['admin_page']
            redirect_to('/admin/groups')
          else
            redirect_to(@group) 
          end
        }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
        format.json { render :json => @group.to_json, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json { render :json => @group.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end


  def update
    sleep 4  # required for photo upload
    @group = Group.find(params[:id])
    respond_to do |format|
      if @group.update_attributes(params[:group])       
        if params[:group_photo] && params[:group_photo].size != 0 
          # remove old profile photos
          Photo.destroy_all("group_id = " + @group.id.to_s + " AND is_profile = true")
          profile_photo = ProfilePhoto.create!(:group_id=>@group.id, :is_profile=>true, :uploaded_data => params[:group_photo]) if params[:group_photo].size != 0 
          @group.profile_photo = profile_photo
        end         
        flash[:notice] = 'Group was successfully updated.'
        format.html { 
          if params['admin_page']
            redirect_to('/admin/groups')
          else
            redirect_to(@group) 
          end
        }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json  { render :json => @group.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end

  def new_forum_topic
    @group = Group.find(params[:id])
    @forum_topic = ForumTopic.new
  end

  def upload
    @group = Group.find(params[:id])
    @show_full = true
  end

  def do_the_upload
    # = Asset.new(params[:asset])
    @asset = Asset.create(params[:asset])
    redirect_to :controller => 'groups' , :action => 'show', :id => params[:asset][:group_id]
  end


  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
      format.json { head :ok } 
    end
  end
end


class WidgetsController < ApplicationController
  
  before_filter :login_required, :only => [:new, :edit, :create, :update]
  
  

  def load
    # get name of widget to load
    @widget_name = params[:name]
    content_id = params[:content_id]  # HTML widgets also pass a content_id which is used to identify content in the db 
    if content_id
      @content = HtmlContent.find_by_content_id(content_id)
      if !@content
        # create content
        HtmlContent.create(:title=>'New Content', :body=>'Add Some Content', :content_id=>content_id)
        @content = HtmlContent.find_by_content_id(content_id)
      end
      render :template=>'widgets/html_content_home', :layout => 'widget'
    else
      if params[:include_friends]
        include_friends = true
      end
      if params[:only_statuses]
        only_statuses = true
      end
      render :template=>'widgets/'+ @widget_name, :locals=>{:include_friends=>include_friends}, :layout => 'widget'
    end
  end
  
  
  # Called via an AJAX method to load a widget into a profile page
  # The widgets to be loaded are defined in the Configuration model class.
  def load_profile_widget
    # get name of widget to load
    @widget_name = params[:name]
    user_id = params[:user_id]
    content_id = params[:content_id]  # HTML widgets also pass a content_id which is used to identify content in the db 
    if content_id
      @content = HtmlContent.find_by_content_id(content_id)
      if !@content
        # create content
        HtmlContent.create(:title=>'New Content', :body=>'Add Some Content', :content_id=>content_id)
        @content = HtmlContent.find_by_content_id(content_id)
      end
      render :template=>'widgets/html_content_home', :layout => 'widget'
    else
      if params[:include_friends]
        include_friends = true
      end
      if params[:only_statuses]
        only_statuses = true
      end
      render :template=>'widgets/' + @widget_name, :locals=>{:include_friends=>include_friends, :only_statuses=>only_statuses, :user_id=>user_id}, :layout => 'widget'
    end
  end


  def grid_data
    @widgets = Widget.find(:all)
    respond_to do |format|
      format.xml { render :partial => 'widgets/griddata.xml.builder', :layout=>false }
    end
  end


end

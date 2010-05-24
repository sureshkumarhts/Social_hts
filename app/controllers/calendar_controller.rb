class CalendarController < ApplicationController

 before_filter :login_required

  def index
    if params[:id]
    @group = Group.find(params[:id])
    end
    @month = params[:month].to_i
    @year = params[:year].to_i
   
    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month, @group.id)
    
  end
  
end
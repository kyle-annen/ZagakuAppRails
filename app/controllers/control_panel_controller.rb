include ControlPanelHelper

class ControlPanelController < ApplicationController
  before_action :require_employee

  def index
    @users = User.all
    @panels = %w[authorization calendars alerts]
    @calendars = Calendar.all
    @page = cp_params[:page] unless cp_params[:page].nil?
    @cp_action = cp_params[:cp_action] unless cp_params[:cp_action].nil?
  end

  def update
    @page = 'authorization'
    result = User.find(cp_params[:user_id].to_i)
                 .update(employee: cp_params[:employee] == 'true')
    if result
      flash[:notice] = 'User permissions updated.'
    else
      flash[:danger] = 'User permissions could not be created.'
    end
    redirect_to '/control-panel/authorization'
  end

  def new
    ical_link_valid = ControlPanelHelper
                      .valid_ical_link(cp_params[:google_ical_link])
    name_valid = !Calendar.all
                          .pluck(:name)
                          .include?(cp_params[:calendar_name])
    if ical_link_valid && name_valid
      create_calendar
      flash[:notice] = 'Calendar created successfully'
      redirect_to '/control-panel/calendars'
    else
      flash[:alert] = 'Calendar name taken' unless name_valid
      flash[:alert] = 'Invalid iCal link' unless ical_link_valid
      redirect_to '/control-panel/calendars?cp_action=add'
    end
  end

  def sync_calendars
    EventJob.perform_now
    flash[:notice] = 'Calendar sync complete'
    redirect_to '/control-panel/calendars'
  end

  def delete_calendar
    calendar = Calendar.find(cp_params[:calendar_id])
    calendar.events.delete_all
    calendar.delete
  end

  private

  def create_calendar
    cal = Calendar.new
    cal.name = cp_params[:calendar_name]
    cal.google_ical_link = cp_params[:google_ical_link]
    cal.time_zone = cp_params[:calendar][:time_zone]
    cal.save
  end

  def cp_params
    params.permit(:user_id,
                  :employee,
                  :utf8,
                  :authenticity_token,
                  :commit,
                  :page,
                  :cp_action,
                  :calendar_name,
                  :calendar_id,
                  :google_ical_link,
                  :_method,
                  calendar: {})
  end

  def require_employee
    redirect_to root_path unless current_user && current_user[:employee]
  end
end

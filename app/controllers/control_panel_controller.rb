class ControlPanelController < ApplicationController
  before_action :require_employee

  def index
    puts cp_params
    @users = User.all
    @panels = ['authorization', 'calendars', 'alerts']
    @page = cp_params[:page] unless cp_params[:page].nil?
    @action = cp_params[:action] unless cp_params[:action].nil?
  end

  def update
    @page = 'Authorization'
    user = User.find(cp_params[:user_id].to_i)
    employee_boolean = cp_params[:employee] == 'true'
    user.employee = employee_boolean
    result = user.save
    if result
      flash[:notice] = 'User permissions updated.'
    else
      flash[:danger] = 'User permissions could not be created.'
    end
    redirect_to "/control-panel/authorization"
  end

  private

  def cp_params
    params.permit(:user_id,
                  :employee,
                  :utf8,
                  :authenticity_token,
                  :commit,
                  :page,
                  :action)
  end

  def require_employee
    redirect_to root_path unless current_user && current_user[:employee]
  end
end

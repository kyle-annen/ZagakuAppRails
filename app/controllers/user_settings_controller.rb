class UserSettingsController < ApplicationController
  def show
    @user = User.find(current_user.id)
    @calendars = Calendar.all
  end

  def update
    user = User.find(user_params[:user_id])
    user.email = user_params[:email]
    user.first_name = user_params[:first_name]
    user.last_name = user_params[:last_name]
    user.preferred_calendar = user_params[:preferred_calendar]
    result = user.save
    if result
      flash[:notice] = "User settings updated"
    else
      flash[:alert] = "User setting could not be updated"
    end
    redirect_to '/user/settings'
  end

  private

  def user_params
    params.permit(:user_id, :email, :first_name, :last_name, :preferred_calendar)
  end
end

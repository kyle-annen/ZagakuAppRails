require 'rails_helper'

RSpec.describe ControlPanelController, type: :controller do
  describe 'index#get' do
    render_views

    it 'redirects to home if user is not authorized' do
      User.create(
        email: 'test@test.com',
        password: Devise.friendly_token[0, 20],
        first_name: 'test',
        last_name: 'test'
      )

      sign_in(User.first)

      get :index

      expect(response).to redirect_to(root_path)
    end

    it 'renders page if user is authorized' do
      User.create(
        email: 'test@8thlight.com',
        password: Devise.friendly_token[0, 20],
        first_name: 'test',
        last_name: 'test'
      )

      sign_in(User.first)

      get :index
      expect(response).to render_template('control_panel/index')

      get :index, params: { page: 'authorization' }
      expect(response).to render_template(partial: '_authorization')

      get :index, params: { page: 'calendars' }
      expect(response).to render_template(partial: '_calendars')

      get :index, params: { page: 'alerts' }
      expect(response).to render_template(partial: '_alerts')
    end
  end

  describe 'update' do
    it 'updates the employee value for the employee checkbox un-ticked' do
      User.create(
        email: 'test@8thlight.com',
        password: Devise.friendly_token[0, 20],
        first_name: 'test',
        last_name: 'test'
      )

      User.create(
        email: 'test@gmail.com',
        password: Devise.friendly_token[0, 20],
        first_name: 'test',
        last_name: 'test'
      )

      @user_valid_employee = User.where(employee: true).first
      @user_invalid_employee = User.where(employee: false).first
      user_id = @user_valid_employee[:id]

      sign_in(@user_valid_employee)

      post :update, params: { user_id: user_id, employee: false }

      expect(User.find(user_id).employee).to be_falsey
    end

    it 'updates the employee value for the employee checkbox when ticked' do
      User.create(
        email: 'test@8thlight.com',
        password: Devise.friendly_token[0, 20],
        first_name: 'test',
        last_name: 'test'
      )

      User.create(
        email: 'test@gmail.com',
        password: Devise.friendly_token[0, 20],
        first_name: 'test',
        last_name: 'test'
      )

      @user_valid_employee = User.where(employee: true).first
      @user_invalid_employee = User.where(employee: false).first
      user_id = @user_invalid_employee[:id]

      sign_in(@user_valid_employee)

      post :update, params: { user_id: user_id, employee: true }

      expect(User.find(user_id).employee).to be_truthy
    end
  end
end

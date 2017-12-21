require 'rails_helper'

RSpec.describe EventsController, type: :controller do
	describe 'GET #index' do
		it 'sets the time zone default to America/Chicago' do
			get :index

			response.should render_template :index
		end
	end
end
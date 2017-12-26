require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'GET #index' do
    it 'renders the index' do
      get :index

      expect(response).to render_template(:index)
    end
  end
end

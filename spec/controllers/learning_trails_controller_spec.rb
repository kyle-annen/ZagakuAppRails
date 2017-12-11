require 'rails_helper'

RSpec.describe LearningTrailsController, type: :controller do

  describe 'index' do
    it 'renders the index page' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'returns an active record relation of all Categories' do
      Category.create([
                        { category: 'testing' },
                        { category: 'music' },
                        { category: 'sports' },
                        { category: 'programing' },
                        { category: 'design' }
                      ])

      get :index

      expect(Category.all).to eq(assigns(:categories))
    end
  end
end

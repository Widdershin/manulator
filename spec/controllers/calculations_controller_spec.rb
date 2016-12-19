require 'rails_helper'

RSpec.describe CalculationsController, type: :controller do
  describe '#new' do
    it 'renders the new template with 200 OK' do
      get :new

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    it 'renders the show template with 201 Created' do
      post :create, params: { number: 1, colour: 'G', by_turn: 2 }

      expect(response).to have_http_status(:created)
      expect(response).to render_template(:show)
    end
  end
end

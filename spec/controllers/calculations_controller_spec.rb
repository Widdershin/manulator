require 'rails_helper'

describe CalculationsController, type: :controller do
  describe '#new' do
    it 'renders the new template with 200 OK' do
      get :new

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    let(:requirements) { { white: 1, black: 1, red: 1, green: 0, blue: 0, colorless: 0 } }

    before { expect(CalculateManaBase).to receive(:new).and_return(-> { [] }) }

    it 'renders the show template with 200 Ok' do
      post :create, params: { mana_requirements: requirements, by_turn: 3 }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
    end
  end
end

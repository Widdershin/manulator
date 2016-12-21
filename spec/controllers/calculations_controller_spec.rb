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
    let(:constraints) do
      {
        constraint_0: { amount: '1', color: 'green', turn: '0' },
        constraint_1: { amount: '1', color: 'blue', turn: '0' }
      }
    end

    let(:mana_constraints) do
      {
        green: { count: 1, turn: 0 },
        blue: { count: 1, turn: 0 }
      }
    end

    let(:lands_to_consider) { ["Spirebluff Canal"] }

    before do
      expect(CalculateManaBase)
        .to receive(:new)
        .with(mana_constraints, lands_to_consider)
        .and_return(-> { [] })
    end

    it 'renders the show template with 200 Ok' do
      post :create, params: { calculations: constraints, non_basic_lands: ["Spirebluff Canal"] }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
    end
  end
end

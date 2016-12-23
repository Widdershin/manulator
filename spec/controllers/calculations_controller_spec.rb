require 'rails_helper'

describe CalculationsController, type: :controller do
  let(:white_constraint) { CalculationsController::ManaConstraint.new(:white, 1, 'at least', 0) }
  let(:blue_constraint) { CalculationsController::ManaConstraint.new(:blue, 1, 'at least', 0) }

  before do
    ManaSource.destroy_all
    ManaSource.create!(white: true, blue: false, black: false, red: false, green: false, colorless: false, name: 'plains', basic: true)
    ManaSource.create!(white: false, blue: true, black: false, red: false, green: false, colorless: false, name: 'island', basic: true)
    ManaSource.create!(white: false, blue: false, black: false, red: true, green: false, colorless: false, name: 'mountain', basic: true)
    ManaSource.create!(white: false, blue: true, black: false, red: true, green: false, colorless: false, name: 'spirebluff_canal', basic: false)
  end

  after do
    ManaSource.destroy_all
  end

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
        constraint_0: { amount: '1', quantifier: 'at least', color: 'white', turn: '0' },
        constraint_1: { amount: '1', quantifier: 'at least', color: 'blue', turn: '0' }
      }
    end

    let(:mana_constraints) { [white_constraint, blue_constraint] }

    let(:lands_to_consider) { ["spirebluff canal", "plains", "island"] }

    before do
      expect(CalculateManaBase)
        .to receive(:new)
        .with(mana_constraints, lands_to_consider)
        .and_return(-> { [] })
    end

    it 'renders the show template with 200 Ok' do
      post :create, params: { calculations: constraints, non_basic_lands: ["spirebluff canal"] }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
    end
  end
end

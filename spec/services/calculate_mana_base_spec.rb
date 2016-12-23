require 'spec_helper'

describe CalculateManaBase do
  let(:service) { described_class.new(mana_constraints, lands_to_consider) }
  let(:result) { service.call }
  let(:white_constraint) { CalculationsController::ManaConstraint.new(:white, 1, quantifier, 0) }
  let(:blue_constraint) { CalculationsController::ManaConstraint.new(:blue, 1, quantifier, 0) }
  let(:red_constraint) { CalculationsController::ManaConstraint.new(:red, 1, quantifier, 0) }
  let(:mana_constraints) { [white_constraint, blue_constraint] }
  let(:quantifier) { 'at least' }


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

  context 'with 1 mana desired for each of 2 colors' do
    let(:lands_to_consider) { ["plains", "island"] }

    it 'returns the most optimal manabase as an even split of the 2 colors' do
      expect(result.first[:island]).to eq(CalculateManaBase::MANA_SOURCES / 2)
      expect(result.first[:plains]).to eq(CalculateManaBase::MANA_SOURCES / 2)
    end
  end

  context 'with 1 mana desired for each of 3 colors' do
    let(:lands_to_consider) { ["plains", "spirebluff_canal", "island", "mountain"] }
    let(:mana_constraints) { [white_constraint, blue_constraint, red_constraint] }

    it 'returns the most optimal manabase as an even split of the 2 colors' do
      expect(result.first[:spirebluff_canal]).to eq(4)
      expect(result.first[:plains]).to be > result.first[:island]
      expect(result.first[:plains]).to be > result.first[:mountain]
    end
  end

  context 'when the number of turns is increased' do
    let(:lands_to_consider) { ["plains", "island"] }
    let(:mana_constraints_turn_zero) { [white_constraint, blue_constraint]}

    let(:mana_constraints_turn_one) { 
      [
        CalculationsController::ManaConstraint.new(:white, 1, quantifier, 0),
        CalculationsController::ManaConstraint.new(:blue, 1, quantifier, 1)
      ]
    }

    let(:no_turns) { described_class.new(mana_constraints_turn_zero, lands_to_consider) }
    let(:one_turn) { described_class.new(mana_constraints_turn_one, lands_to_consider) }

    it 'returns a higher probability to draw the required mana' do
      expect(no_turns.call.first[:probability]).to be < one_turn.call.first[:probability]
    end
  end

  context 'with uneven mana desired for each of 2 colors' do
    let(:lands_to_consider) { ["plains", "island"] }
    let(:white_constraint) { CalculationsController::ManaConstraint.new(:white, 3, quantifier, 10) }
    let(:blue_constraint) { CalculationsController::ManaConstraint.new(:blue, 1, quantifier, 10) }
    let(:mana_constraints) { [white_constraint, blue_constraint]}

    it 'returns uneven ratio of the 2 colors' do
      expect(result.first[:island]).to be < result.first[:plains]
    end
  end

  context 'with multiple quantifier' do
    let(:lands_to_consider) { ["plains", "island"] }
    let(:white_constraint) { CalculationsController::ManaConstraint.new(:white, 3, 'no more than', 10) }
    let(:blue_constraint) { CalculationsController::ManaConstraint.new(:blue, 1, 'exactly', 10) }
    let(:mana_constraints) { [white_constraint, blue_constraint]}

    it 'does some cool stuff' do
      expect(result.first[:island]).to be < result.first[:plains]
    end
  end
end

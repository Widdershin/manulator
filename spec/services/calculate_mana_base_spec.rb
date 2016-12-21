require 'spec_helper'

describe CalculateManaBase do
  let(:service) { described_class.new(mana_desired, lands_to_consider) }
  let(:result) { service.call }

  before do
    ManaSource.destroy_all
    ManaSource.create!(white: true, blue: false, black: false, red: false, green: false, colorless: false, name: 'plains', basic: true)
    ManaSource.create!(white: false, blue: true, black: false, red: false, green: false, colorless: false, name: 'island', basic: true)
    ManaSource.create!(white: false, blue: false, black: false, red: true, green: false, colorless: false, name: 'mountain', basic: true)
    ManaSource.create!(white: false, blue: true, black: false, red: true, green: false, colorless: false, name: 'spirebluff_canal', basic: false)
  end

  context 'with 1 mana desired for each of 2 colors' do
    let(:lands_to_consider) { ["plains", "island"] }
    let(:mana_desired) { 
      {
        blue: { count: 1, turn: 0 },
        white: { count: 1, turn: 0 } 
      } 
    }

    it 'returns the most optimal manabase as an even split of the 2 colors' do

      expect(result.first[:island]).to eq(CalculateManaBase::MANA_SOURCES / 2)
      expect(result.first[:plains]).to eq(CalculateManaBase::MANA_SOURCES / 2)
    end
  end

  context 'with 1 mana desired for each of 3 colors' do
    let(:lands_to_consider) { ["plains", "spirebluff_canal", "island", "mountain"] }
    let(:mana_desired) { 
      {
        blue: { count: 1, turn: 0 },
        white: { count: 1, turn: 0 },
        red: { count: 1, turn: 0 }
      } 
    }

    it 'returns the most optimal manabase as an even split of the 2 colors' do
      expect(result.first[:spirebluff_canal]).to eq(4)
      expect(result.first[:plains]).to be > result.first[:island]
      expect(result.first[:plains]).to be > result.first[:mountain]
    end
  end

  context 'when the number of turns is increased' do
    let(:lands_to_consider) { ["plains", "island"] }
    let(:mana_desired_turn_zero) { 
      {
        blue: { count: 1, turn: 0 },
        white: { count: 1, turn: 0 } 
      } 
    }

    let(:mana_desired_turn_one) { 
      {
        blue: { count: 1, turn: 1 },
        white: { count: 1, turn: 1 } 
      } 
    }

    let(:no_turns) { described_class.new(mana_desired_turn_zero, lands_to_consider) }
    let(:one_turn) { described_class.new(mana_desired_turn_one, lands_to_consider) }

    it 'returns a higher probability to draw the required mana' do
      expect(no_turns.call.first[:probability]).to be < one_turn.call.first[:probability]
    end
  end
end

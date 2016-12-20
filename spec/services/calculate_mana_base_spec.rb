require 'spec_helper'

describe CalculateManaBase do
  let(:service) { described_class.new(mana_desired) }
  let(:result) { service.call }
  let(:by_turn) { 0 }

  context 'with 1 mana desired for each of 2 colors' do
    let(:mana_desired) { 
      {
        blue: { count: 1, turn: 0 },
        white: { count: 1, turn: 0 } 
      } 
    }

    it 'returns the most optimal manabase as an even split of the 2 colors' do
      expect(result).to eq([])
      expect(result.first[:blue]).to eq(CalculateManaBase::MANA_SOURCES / 2)
      expect(result.first[:white]).to eq(CalculateManaBase::MANA_SOURCES / 2)
    end
  end

  context 'with 1 mana desired for each of 3 colors' do
    let(:mana_desired) { { blue: 1, white: 1, red: 1 } }

    it 'returns the most optimal manabase as an even split of the 2 colors' do
      expect(result.first[:blue]).to eq(CalculateManaBase::MANA_SOURCES / 3)
      expect(result.first[:white]).to eq(CalculateManaBase::MANA_SOURCES / 3)
      expect(result.first[:red]).to eq(CalculateManaBase::MANA_SOURCES / 3)
    end
  end

  context 'when the number of turns is increased' do
    let(:mana_desired) { { white: 1, blue: 1 } }
    let(:no_turns) { described_class.new(mana_desired, 0).call.first }
    let(:one_turn) { described_class.new(mana_desired, 1).call.first }

    it 'returns a higher probability to draw the required mana' do
      expect(no_turns[:probability]).to be < one_turn[:probability]
    end
  end
end

require 'spec_helper'

describe CalculateManaBase do
  let(:service) { described_class.new(mana_desired) }
  let(:result) { service.call }
  let(:by_turn) { 0 }
  let(:plains) { instance_double("ManaSource", white: true, blue: false, black: false, red: false, green: false, colorless: false, name: 'plains', basic: true) }
  let(:island) { instance_double("ManaSource", white: false, blue: true, black: false, red: false, green: false, colorless: false, name: 'island', basic: true) }
  let(:mountain) { instance_double("ManaSource", white: false, blue: false, black: false, red: true, green: false, colorless: false, name: 'mountain', basic: true) }
  let(:spirebluff_canal) { instance_double("ManaSource", white: false, blue: true, black: false, red: true, green: false, colorless: false, name: 'spirebluff_canal', basic: false) }

  context 'with 1 mana desired for each of 2 colors' do
    let(:mana_desired) { 
      {
        blue: { count: 1, turn: 0 },
        white: { count: 1, turn: 0 } 
      } 
    }

    it 'returns the most optimal manabase as an even split of the 2 colors' do
      expect(service).to receive(:colors_to_sources).and_return([plains, island]).at_least(:once)

      expect(result.first[:island]).to eq(CalculateManaBase::MANA_SOURCES / 2)
      expect(result.first[:plains]).to eq(CalculateManaBase::MANA_SOURCES / 2)
    end
  end

  context 'with 1 mana desired for each of 3 colors' do
    let(:mana_desired) { 
      {
        blue: { count: 1, turn: 0 },
        white: { count: 1, turn: 0 },
        red: { count: 1, turn: 0 }
      } 
    }

    it 'returns the most optimal manabase as an even split of the 2 colors' do
      expect(service).to receive(:colors_to_sources).and_return([plains, island, mountain, spirebluff_canal]).at_least(:once)
      expect(service).to receive(:colors_to_sources).and_return([plains, island, mountain, spirebluff_canal]).at_least(:once)
      expect(result.first[:spirebluff_canal]).to eq(4)
      expect(result.first[:plains]).to be > result.first[:island]
      expect(result.first[:plains]).to be > result.first[:mountain]
    end
  end

  context 'when the number of turns is increased' do
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

    let(:no_turns) { described_class.new(mana_desired_turn_zero) }
    let(:one_turn) { described_class.new(mana_desired_turn_one) }

    it 'returns a higher probability to draw the required mana' do
      expect(no_turns).to receive(:colors_to_sources).and_return([plains, island]).at_least(:once)
      expect(one_turn).to receive(:colors_to_sources).and_return([plains, island]).at_least(:once)
      expect(no_turns.call.first[:probability]).to be < one_turn.call.first[:probability]
    end
  end
end

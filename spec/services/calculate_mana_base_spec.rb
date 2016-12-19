require 'spec_helper'

describe CalculateManaBase do
  let(:service) { described_class.new(mana_desired, by_turn) }
  let(:result) { service.call }

  context 'with three colours' do
    let(:mana_desired) { { red: 2, blue: 1, white: 1 } }

    context 'with 7 draws' do
      let(:by_turn) { 0 }

      it 'returns the correct results, in order of most probable first' do
        expect(result.count).to eq(15)

        expect(result).to eq(
          [
            { red: 12, blue: 6, white: 6, probability: 4.3926 },
            { red: 13, blue: 6, white: 5, probability: 4.3261 },
            { red: 13, blue: 5, white: 6, probability: 4.3261 },
            { red: 11, blue: 6, white: 7, probability: 4.2706 },
            { red: 12, blue: 7, white: 5, probability: 4.2706 },
            { red: 11, blue: 7, white: 6, probability: 4.2706 },
            { red: 12, blue: 5, white: 7, probability: 4.2706 },
            { red: 14, blue: 5, white: 5, probability: 4.2059 },
            { red: 10, blue: 7, white: 7, probability: 4.0765 },
            { red: 11, blue: 8, white: 5, probability: 4.0672 },
            { red: 11, blue: 5, white: 8, probability: 4.0672 },
            { red: 13, blue: 7, white: 4, probability: 4.0377 },
            { red: 14, blue: 4, white: 6, probability: 4.0377 },
            { red: 14, blue: 6, white: 4, probability: 4.0377 },
            { red: 13, blue: 4, white: 7, probability: 4.0377 }
          ]
        )
      end
    end
  end
end

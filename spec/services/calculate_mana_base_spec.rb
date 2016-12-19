require 'spec_helper'

RSpec.describe CalculateManaBase do
  let(:service) { described_class.new(mana_desired, by_turn) }

  context 'with three colours' do
    let(:mana_desired) { { red: 2, blue: 1, white: 1 } }

    context 'with 7 draws' do
      let(:by_turn) { 0 }

      it 'does a thing' do
        expect(service.call.count).to eq(15)
      end
    end
  end
end

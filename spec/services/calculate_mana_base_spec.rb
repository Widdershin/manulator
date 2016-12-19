require 'spec_helper'

RSpec.describe CalculateManaBase do
  let(:service) { described_class.new(amounts_desired, draws) }

  context 'with three colours' do
    # let(:colors_desired) { %w(blue red white) }
    let(:amounts_desired) { { red: 2, blue: 1, white: 1 } }

    context 'with 10 draws' do
      let(:draws) { 7 }

      it 'does a thing' do
        expect(service.call.count).to eq(15)
      end
    end
  end
end

require 'spec_helper'

describe MHD do
  let(:draws) { 7 }
  let(:card_distribution) { { white: 12, blue: 12, non_mana_sources: 36 } }
  let(:hand) { { white: 3, blue: 3, non_mana_sources: 0 } }
  let(:mhd) { MHD.new(distribution: card_distribution) }

  it 'calculates probability' do
    expect(mhd.call(amounts_desired: hand.values, draws: draws)).to eq(0.00012532142096262803)
  end
end

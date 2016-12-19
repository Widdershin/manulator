require 'multivariate_hypergeometric_distribution.rb'

class CalculateManaBase
  attr_reader :colors_desired, :mana_desired, :draws

  COLORS = [:white, :blue, :black, :red, :green, :colorless]
  CARDS_IN_DECK = 60
  MANA_SOURCES = 24
  CONFIDENCE = 4 # percent
  CARDS_IN_OPENING_HAND = 7

  def initialize(mana_desired, by_turn)
    @colors_desired = mana_desired.keys
    @mana_desired = mana_desired.sort_by { |color, _v| COLORS.index(color) }.to_h
    @draws = by_turn.to_i + CARDS_IN_OPENING_HAND
  end

  def call
    successful_mana_bases.sort_by { |h| h[:probability] }.reverse!
  end

  private

  def successful_mana_bases
    mana_base_combinations.map.with_object([]) do |combination, successes|
      card_distribution = combination.merge(non_mana_sources: CARDS_IN_DECK - MANA_SOURCES)

      mhd = MHD.new(distribution: card_distribution)

      probability = possible_hands.sum do |hand|
        amounts_desired = hasherizer(hand).values
        prob = mhd.call(amounts_desired: amounts_desired, draws: draws)
        p "probability: #{prob}"
        p "hand: #{hand}"
        p "hasherized values: #{amounts_desired}"
        prob
      end * 100

      successes << combination.merge(probability: probability.round(4)) if probability > CONFIDENCE
    end
  end

  def possible_hands
    (colors_desired + [:non_mana_sources]).repeated_combination(draws).reject { |hand| satisfies_requirements?(hand) }
  end

  def satisfies_requirements?(hand)
    # this doesn't reject hands that are impossible given a card distribution
    # for example, we want blue, red and white mana, and it gives us a possible hand of 
    # 2 white, 1 red, and 1 blue, but our mana base only has 1 plains in it. This hand needs to be rejected
    mana_desired.all? do |color, amount|
      amount >= hand.count(color)
    end
  end

  def mana_base_combinations
    colors_desired.repeated_combination(MANA_SOURCES).map do |combination|
      result = {}

      colors_desired.each { |color| result[color] = combination.count(color) }

      result
    end
  end

  def hasherizer(array)
    colors_desired.push(:non_mana_sources).map.with_object({}) do |color, hash|
      hash[color] = array.count(color)
    end.sort_by { |color, _v| COLORS.index(color) || COLORS.length }.to_h
  end

  def amounts_desired
    mana_sources_desired << non_mana_sources_desired
  end

  def mana_sources_desired
    mana_desired.values.map(&:to_i)
  end

  def non_mana_sources_desired
    draws - mana_sources_desired.sum
  end
end

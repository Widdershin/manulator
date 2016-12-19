require 'multivariate_hypergeometric_distribution.rb'

class CalculateManaBase
  attr_reader :colors_desired, :mana_desired, :draws

  CARDS_IN_DECK = 60
  MANA_SOURCES = 24
  CONFIDENCE = 4 # percent
  CARDS_IN_OPENING_HAND = 7

  def initialize(mana_desired, by_turn)
    @colors_desired = mana_desired.keys
    @mana_desired = mana_desired
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

      probability = mhd.call(amounts_desired: amounts_desired, draws: draws) * 100

      successes << combination.merge(probability: probability.round(4)) if probability > CONFIDENCE
    end
  end

  def mana_base_combinations
    colors_desired.repeated_combination(MANA_SOURCES).map do |combination|
      result = {}

      colors_desired.each { |color| result[color] = combination.count(color) }

      result
    end
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

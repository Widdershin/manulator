require 'multivariate_hypergeometric_distribution.rb'

class CalculateManaBase
  attr_reader :colors_desired, :mana_desired, :draws

  COLORS = %i(white blue black red green colorless).freeze
  CARDS_IN_DECK = 60
  MANA_SOURCES = 24
  CONFIDENCE = 10 # percent
  CARDS_IN_OPENING_HAND = 7

  def initialize(mana_desired, by_turn)
    @colors_desired = mana_desired.select { |_color, count| count.nonzero? }.keys
    @mana_desired = mana_desired.sort_by { |color, _count| COLORS.index(color) }.to_h
    @draws = by_turn + CARDS_IN_OPENING_HAND
  end

  def call
    successful_mana_bases.sort_by { |h| h[:probability] }.reverse!
  end

  private

  def successful_mana_bases
    mana_base_combinations.map.with_object([]) do |combination, successes|
      card_distribution = combination.merge(non_mana_sources: CARDS_IN_DECK - MANA_SOURCES)

      mhd = MHD.new(distribution: card_distribution)

      probability = possible_hands_for_mana_base(card_distribution).sum do |hand|
        mhd.call(amounts_desired: hand.values, draws: draws)
      end * 100

      successes << combination.merge(probability: probability.round(4)) if probability > CONFIDENCE
    end
  end

  def possible_hands_for_mana_base(card_distribution)
    hands_with_required_mana_sources.select do |hand|
      hand.all? do |color, count|
        card_distribution[color] >= count
      end
    end
  end

  def hands_with_required_mana_sources
    @hands ||= possible_hands.map { |hand| hasherize(hand) if satisfies_mana_requirements?(hand) }.compact
  end

  def possible_hands
    (colors_desired + [:non_mana_sources]).repeated_combination(draws)
  end

  def satisfies_mana_requirements?(hand)
    mana_desired.all? { |color, amount| hand.count(color) >= amount }
  end

  def mana_base_combinations
    colors_desired.repeated_combination(MANA_SOURCES).map do |combination|
      result = {}

      colors_desired.each { |color| result[color] = combination.count(color) }

      result
    end
  end

  def hasherize(array)
    (colors_desired + [:non_mana_sources]).map.with_object({}) do |color, hash|
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

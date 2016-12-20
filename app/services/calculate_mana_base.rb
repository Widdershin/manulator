require 'multivariate_hypergeometric_distribution.rb'

class CalculateManaBase
  attr_reader :mana_constraints

  COLORS = %i(white blue black red green colorless).freeze
  CARDS_IN_DECK = 60
  MANA_SOURCES = 24
  CONFIDENCE = 0 # percent
  CARDS_IN_OPENING_HAND = 7

  ManaConstraint = Struct.new(:color, :count, :turn)

  def initialize(mana_constraints)
    @mana_constraints = mana_constraints
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
        p_hand = mhd.call(amounts_desired: hasherize(hand).values, draws: draws)
      end * 100

      successes << combination.merge(probability: probability.round(4)) if probability > CONFIDENCE
    end
  end

  def mana_constraints
    @mana ||= @mana_constraints
      .map { |color, details| ManaConstraint.new(color, details[:count], details[:turn]) }
      .sort_by { |constraint| COLORS.index(constraint.color) }
  end

  def colors_desired
    @colors_desired ||= mana_constraints.map { |constraint| constraint.color if constraint.count.nonzero? }.compact
  end

  def draws
    @draws ||= mana_constraints.map { |constraint| constraint.turn + CARDS_IN_OPENING_HAND }.max
  end

  def possible_hands_for_mana_base(card_distribution)
    hands_with_required_mana_sources.select do |hand|
      hasherize(hand).all? do |color, count|
        card_distribution[color] >= count
      end
    end
  end

  def hands_with_required_mana_sources
    @hands ||= possible_hands.select { |hand| satisfies_mana_requirements?(hand) }
  end

  def possible_hands
    card_types.repeated_combination(draws)
  end

  def satisfies_mana_requirements?(hand)
    mana_constraints.all? do |constraint| 
      hand.count(constraint.color) >= constraint.count
    end
  end

  def mana_base_combinations
    colors_desired.repeated_combination(MANA_SOURCES).map do |combination|
      result = {}

      colors_desired.each { |color| result[color] = combination.count(color) }

      result
    end
  end

  def hasherize(array)
    card_types.map.with_object({}) do |color, hash|
      hash[color] = array.count(color)
    end.sort_by { |color, _v| COLORS.index(color) || COLORS.length }.to_h
  end

  def amounts_desired_for(count, color)
    card_types.map { |mana_color| mana_color == color ? count : 0 }
  end

  def card_types
    (colors_desired + [:non_mana_sources])
  end
end

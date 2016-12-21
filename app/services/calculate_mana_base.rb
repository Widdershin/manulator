require 'multivariate_hypergeometric_distribution.rb'

class CalculateManaBase
  attr_reader :mana_constraints

  COLORS = %i(white blue black red green colorless).freeze
  CARDS_IN_DECK = 60
  MANA_SOURCES = 24
  CONFIDENCE = 30 # percent
  CARDS_IN_OPENING_HAND = 7

  ManaConstraint = Struct.new(:color, :count, :turn)
  NonSource = Struct.new(:white, :blue, :black, :red, :green, :colorless, :name, :basic)

  def initialize(mana_constraints, lands_to_consider)
    @mana_constraints = mana_constraints
    @lands_to_consider = lands_to_consider
  end

  def call
    successful_mana_bases.sort_by { |h| h[:probability] }.reverse!
  end

  private

  def successful_mana_bases
    mana_base_combinations.map.with_object([]) do |combination, successes|
      card_distribution = combination.merge(non_mana_source: CARDS_IN_DECK - MANA_SOURCES)

      mhd = MHD.new(distribution: card_distribution)

      probability = possible_hands_for_mana_base(card_distribution).sum do |hand|
        p_hand = mhd.call(amounts_desired: hand.values, draws: draws)
      end * 100

      successes << combination.merge(probability: probability.round(4)) if probability > CONFIDENCE
    end
  end

  def mana_constraints
    @mana ||= @mana_constraints
      .map { |color, details| ManaConstraint.new(color, details[:count], details[:turn]) }
      .sort_by { |constraint| COLORS.index(constraint.color) }
  end

  def draws
    @draws ||= mana_constraints.map { |constraint| constraint.turn + CARDS_IN_OPENING_HAND }.max
  end

  def possible_hands_for_mana_base(card_distribution)
    hands_with_required_mana_sources.select do |hand|
      hand.all? do |source, count|
        card_distribution[source.name.to_sym] >= count
      end
    end
  end

  def hands_with_required_mana_sources
    @hands ||= possible_hands.map { |hand| hasherize(hand) if satisfies_mana_requirements?(hand) }.compact
  end

  def possible_hands
    card_types.repeated_combination(draws)
  end

  def satisfies_mana_requirements?(hand)
    mana_constraints.all? do |constraint|
      hand.count { |source| source.send(constraint.color) } >= constraint.count
    end
  end

  def colors_desired
    @colors_desired ||= mana_constraints.map { |constraint| constraint.color if constraint.count.nonzero? }.compact
  end

  def colors_to_sources
    @colors_to_sources ||= colors_desired.flat_map { |color| ManaSource.where(name: @lands_to_consider) }.uniq.sort_by(&:name)
  end

  def mana_base_combinations
    colors_to_sources.repeated_combination(MANA_SOURCES).map do |combination|
      next if too_many_non_basics?(combination)

      result = {}

      colors_to_sources.each do |source|
        result[source.name.to_sym] = combination.count(source)
      end

      result
    end.compact
  end

  def too_many_non_basics?(mana_base)
    mana_base.any? { |source, count| !source.basic && mana_base.count(source) > 4 }
  end

  def hasherize(array)
    card_types.map.with_object({}) do |source, hash|
      hash[source] = array.count(source)
    end
  end

  def amounts_desired_for(count, color)
    card_types.map { |source| source.send(color) ? count : 0 }
  end

  def card_types
    (colors_to_sources + [NonSource.new(false, false, false, false, false, false, :non_mana_source, false)])
  end
end

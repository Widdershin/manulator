require 'multivariate_hypergeometric_distribution.rb'

class CalculateManaBase
  attr_reader :colors_desired, :mana_constraints, :draws

  COLORS = %i(white blue black red green colorless).freeze
  CARDS_IN_DECK = 60
  MANA_SOURCES = 24
  CONFIDENCE = 0 # percent
  CARDS_IN_OPENING_HAND = 7

  ManaConstraint = Struct.new(:color, :count, :turn)

  def initialize(mana_constraints)
    @mana_constraints = mana_constraints.map { |color, details| ManaConstraint.new(color, details[:count], details[:turn]) }
    @mana_constraints = @mana_constraints.sort_by { |constraint| COLORS.index(constraint.color) }
    @colors_desired = @mana_constraints.map { |constraint| constraint.color if constraint.count.nonzero? }.compact
    @draws = @mana_constraints.map { |constraint| constraint.turn + CARDS_IN_OPENING_HAND }.max
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
        # First, need probability of drawing this particular hand (after however many draws):
        p_hand = mhd.call(amounts_desired: hasherize(hand).values, draws: draws)
        constrained_probs = [p_hand]
        available_cards = draws
        active_distribution = hasherize(hand)
        
        mana_constraints.each do |constraint|
          # are we using constraint.turn?
          current_distribution = MHD.new(distribution: active_distribution)
          amounts_desired = amounts_desired_for(constraint.count, constraint.color)

          # p_constr = current_distribution.call(amounts_desired: amounts_desired, available_cards_for_constraint(turn, available_cards)) # available cards for a constraint will move...
          p_constr = current_distribution.call(amounts_desired: amounts_desired, draws: 1) # available cards for a constraint will move...

          raise "that shit cray" if p_constr.zero?

          constrained_probs << p_constr
          active_distribution = card_types.zip(active_distribution.values.zip(amounts_desired).map { |a, b| a - b }).to_h

          available_cards -= constraint.count
        end

        constrained_probs.reduce(:*)
      end * 100

      # available_cards_for_constraint = how many cards are drawn from 

      # prob_of_exact_hand = mhd.call(amounts_desired: [1, 2, 0, 1, 1, 0, 4], 9) # 0.22
      # red_in_opening_hand = mhd.call(amounts_desired: [0, 0, 0, 1, 0, 0, 0], 7)

      # distr_of_exact_hand = MHD.new(distribution: [1, 2, 0, 1, 1, 0, 4])
      # # each constraint of drawing n cards reduces the remaining draws by n
      # prob_of_red_first_in_exact_hand   = distr_of_exact_hand.call(amounts_desired: [0, 0, 0, 1, 0, 0, 0], CARDS_IN_OPENING_HAND) # some magic
      # prob_of_blue_by_two_in_exact_hand = distr_of_exact_hand.call(amounts_desired: [0, 1, 0, 0, 0, 0, 0], )
      # # Issue: prob_of_blue_by_two_in_exact_hand includes cases where _red_ is *not* drawn
      # # Would, ideally, like the probability _given that_ red is in the opening hand
      # distr_of_exact_hand_after_red = MHD.new(distribution: [1, 2, 0, 0, 1, 0, 4])
      # prob_of_blue_by_two_in_exact_hand_after_red = distr_of_exact_hand.call(amounts_desired: [0, 1, 0, 0, 0, 0, 0], 8)

      successes << combination.merge(probability: probability.round(4)) if probability > CONFIDENCE
    end
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

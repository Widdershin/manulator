require 'multivariate_hypergeometric_distribution.rb'

class CalculateManaBase
  attr_reader :colors_desired, :mana_desired, :successes, :draws

  CARDS_IN_DECK = 60
  MANA_SOURCES = 24
  CONFIDENCE = 4 # percent

  def initialize(mana_desired, draws)
    @colors_desired = mana_desired.keys
    @mana_desired = mana_desired
    @draws = draws
    @successes = []
  end

  def call
    mana_base_combinations.each do |combination|
      card_distribution = combination.merge({
          non_mana_sources: CARDS_IN_DECK - MANA_SOURCES
      })

      mhd = MHD.new(distribution: card_distribution)

      probability = mhd.call(amounts_desired: amounts_desired, draws: draws) * 100

      successes << combination.merge({probability: probability.round(4)}) if probability > CONFIDENCE
    end

    successes
  end

  def amounts_desired
    mana_sources_desired << non_mana_sources_desired
  end

  def mana_sources_desired
    mana_desired.values
  end

  def non_mana_sources_desired
    draws - mana_sources_desired.inject(:+)
  end

  def mana_base_combinations
    combinations = colors_desired.repeated_combination(MANA_SOURCES)

    combinations.map do |combination|
      {
        white: combination.count(:white),
        blue: combination.count(:blue),
        black: combination.count(:black),
        red: combination.count(:red),
        green: combination.count(:green)
      }.delete_if { |key, _value| colors_desired.exclude?(key) }
    end
  end
end

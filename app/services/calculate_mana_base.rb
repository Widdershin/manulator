class CalculateManaBase
  attr_reader :color_distribution, :amounts_desired, :successes, :draws

  CARDS_IN_DECK = 60
  MANA_SOURCES = 24
  CONFIDENCE = 4 # percent

  def intialize(colors_desired, amounts_desired, draws)
    @colors_desired = colors_desired
    @amounts_desired = amounts_desired
    @draws = draws
    @successes = []
  end

  def call
    mana_base_combinations.each do |combination|
      card_distribution = {
        red_sources: combination[:red],
        blue_sources: combination[:blue],
        white_sources: combination[:white],
        non_mana_sources: CARDS_IN_DECK - MANA_SOURCES
      }

      mhd = MHD.new(card_distribution: card_distribution)

      probability = mhd.call(amounts_desired: amounts_desired, draws: draws) * 100

      successes << combination.merge({probability: probability.round(4)}) if probability > CONFIDENCE
    end

    successes
  end

  def amounts_desired
    mana_sources_desired + non_mana_sources_desired
  end

  def mana_sources_desired
    amounts_desired.values
  end

  def non_mana_sources_desired
    draws - mana_sources_desired.inject(:+)
  end

  def mana_base_combinations
    combinations = colors_desired.repeated_combinations(MANA_SOURCES)

    combinations.map do |combination|
      { 
        white: combination.count("white"),
        blue: combination.count("blue"),
        black: combination.count("black"),
        red: combination.count("red"),
        green: combination.count("green"),
      }.delete_if { |_, value| value.zero? }
    end
  end
end

colors_desired = ["blue", "red", "white"]
amounts_desired = {red: 2, blue: 1, white: 1}
draws = 10
CalculateManaBase.new(colors_desired, amounts_desired, draws).call
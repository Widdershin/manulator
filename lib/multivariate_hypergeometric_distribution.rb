require 'byebug'

class MHD
  include Distribution::MathExtension

  attr_reader :population_size, :distribution

  def initialize(distribution: nil)
    @distribution = distribution
    @population_size = distribution.values.sum
  end

  def call(amounts_desired:, draws:)
    raise 'specify the amount desired for each type' unless amounts_desired.size == distribution.size

    number_of_type_to_number_desired = distribution.values.zip(amounts_desired)

    binomial_coefficients = number_of_type_to_number_desired.map do |number_of_type, number_desired|
      binomial_coefficient(number_of_type, number_desired)
    end

    binomial_coefficients.inject(:*).to_f / binomial_coefficient(population_size, draws).to_f
  end
end

# combinations = ["blue", "red", "white"].repeated_combination(24)
# successes = []

# combinations = combinations.map do |combination|
#   {
#     blue: combination.count("blue"),
#     red: combination.count("red"),
#     white: combination.count("white")
#   }
# end

# combinations.each do |combination|
#   card_distribution = {
#     red_sources: combination[:red],
#     blue_sources: combination[:blue],
#     white_sources: combination[:white],
#     non_mana_sources: 36
#   }

#   mhd = MHD.new(distribution: card_distribution)

#   probability = mhd.call(amounts_desired: [2, 1, 1, 3], draws: 7) * 100

#   successes << combination.merge({probability: probability.round(4)}) if probability > 4
# end

# p "possibly combinations are:"
# p successes.sort_by { |success| success[:probability] }.reverse

# p "the amount of successful mana bases is:"
# p successes.count

# for each of these, sum the amount of each color
# then for each of those, calculate the success function

###
# p "does binomial work?"
# p Math.bc(40, 4) == 91390

# # a deck of 60 cards consists of 35 spells, and 8 red, 8 blue, and 9 white sources
# # a random sample of 7 cards is chosen
# card_distribution = {
#   red_sources: 8,
#   blue_sources: 8,
#   white_sources: 9,
#   non_mana_sources: 35
# }

# mhd = MHD.new(distribution: card_distribution)

# p "the probability that the sample of 7 contains exactly:" 
# p "2 red sources, 1 blue source, 1 white source, and 3 non mana sources is:"
# p probability = mhd.call(amounts_desired: [2, 1, 1, 3], draws: 7) * 100


###
  # given 60 cards 
  # and 24 of them are lands
  # and I want at least 1 green on turn 1
  # and I want at least 1 red on turn 3
  # and I want at least 1 blue on turn 3
  # this means a sample of 10 draws, given a starting hand of 7 and 3 additional draws

  # what combinations of lands produce this outcome at 80% confidence

  # success function
  # a function that returns true or false given a distribtion of color sources for
  # my sucess criteria (e.g. the 80%)


# I have 4 slots available
# The slots can be filled with either red or blue marbles
# I want all the possible combinations of slots

# https://en.wikipedia.org/wiki/Hypergeometric_distribution
# http://www.math.uah.edu/stat/dist/Discrete.html

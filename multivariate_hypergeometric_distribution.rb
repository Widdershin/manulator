module Math
  
  # https://rosettacode.org/wiki/Evaluate_binomial_coefficients#Ruby
  # binomial coefficient
  def self.bc(n, k)
    pTop = (n-k+1 .. n).inject(1, &:*) 
    pBottom = (2 .. k).inject(1, &:*)
    pTop / pBottom
  end
end

class MHD
  include Math

  attr_reader :population_size, :card_distribution

  def initialize(card_distribution: nil)
    @card_distribution = card_distribution
    @population_size = card_distribution.values.inject(:+)
  end

  def call(amounts_desired: amounts_desired, draws: draws)
    raise "specify the amount desired for each type" unless amounts_desired.size == card_distribution.size

    number_of_type_to_number_desired = card_distribution.values.zip(amounts_desired)

    binomial_coefficients = number_of_type_to_number_desired.map do |number_of_type, number_desired|
      Math.bc(number_of_type, number_desired)
    end

    binomial_coefficients.inject(:*).to_f / Math.bc(population_size, draws).to_f
  end
end

p "does binomial work?"
p Math.bc(40, 4) == 91390

# a deck of 60 cards consists of 35 spells, 8 red, 8 blue, and 9 white sources
# a random sample of 7 cards is chosen
card_distribution = {
  red_sources: 8,
  blue_sources: 8,
  white_sources: 9,
  non_mana_sources: 35
}

mhd = MHD.new(card_distribution: card_distribution)

p "the probability that the sample contains exactly:" 
p "2 red sources, 1 blue source, 1 white source, and 3 non mana sources is:"
p probability = mhd.call(amounts_desired: [2, 1, 1, 3], draws: 7)

p "MHD works?"
p probability.round(4) == 0.0796

# https://en.wikipedia.org/wiki/Hypergeometric_distribution
# http://www.math.uah.edu/stat/dist/Discrete.html
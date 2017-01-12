class ManaSource < ApplicationRecord
  validates :name, presence: true
  validates :white, :blue, :black, :red, :green, :colorless, :etb_tapped, :basic, inclusion: { in: [true, false] }

  scope :alphabetized, -> { order(name: :asc) }

  COLOR_IDENTITIES = {
    white: 'w',
    blue: 'u',
    black: 'b',
    red: 'r',
    green: 'g',
    colorless: 'c'
  }.freeze

  def colors
    [:white, :blue, :black, :red, :green, :colorless].select { |color| send(color) }
  end
end

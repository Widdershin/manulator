class ManaSource < ApplicationRecord
  validates :name, presence: true
  validates :white, :blue, :black, :red, :green, :colorless, :etb_tapped, :basic, inclusion: { in: [true, false] }
end

class ManaSource < ApplicationRecord
  validates :name, :nonbasic, :white, :blue, :black, :red, :green, :colorless, :etb_tapped,
            presence: true
end

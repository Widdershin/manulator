class CalculationsController < ApplicationController
  COLORS = %w(white blue black red green colorless).freeze

  def new
    @mana_sources = COLORS
    @amounts = (0..10).to_a
  end

  def create
    @turn = params[:by_turn]
    @requirement_description = requirement_params.select { |_k, v| v != '0' }
    @mana_bases = CalculateManaBase.new(requirement_params, @turn).call.first(10)

    render :show
  end

  private

  def requirement_params
    {
      white: params[:white],
      blue: params[:blue],
      black: params[:black],
      red: params[:red],
      green: params[:green],
      colorless: params[:colorless]
    }
  end
end

class CalculationsController < ApplicationController
  COLORS = %w(white blue black red green colorless).freeze

  def new
    @mana_sources = COLORS
    @amounts = (0..10).to_a
  end

  def create
    @turn = params[:by_turn].to_i
    @requirement_description = requirement_params.select { |_k, v| v != '0' }
    @mana_bases = CalculateManaBase.new(requirement_params, @turn).call.first(10)

    render :show
  end

  private

  def requirement_params
    {
      white: params[:white].to_i,
      blue: params[:blue].to_i,
      black: params[:black].to_i,
      red: params[:red].to_i,
      green: params[:green].to_i,
      colorless: params[:colorless].to_i
    }
  end
end

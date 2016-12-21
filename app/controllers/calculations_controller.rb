class CalculationsController < ApplicationController
  COLORS = %w(white blue black red green colorless).freeze

  def new
    @non_basic_lands = ManaSource.where(basic: false).all
    @colors = COLORS
    @amounts = (0..10).to_a
  end

  def create
    @mana_bases = CalculateManaBase.new(mana_constraints).call.first(10)

    render :show
  end

  private

  def mana_constraints
    calculation_params.map do |constraint_params|
      constraint_params_to_mana_constraint(constraint_params)
    end.reduce({}, :merge)
  end

  def calculation_params
    params['calculations'].delete_if do |key, _value|
      key == 'constraint_X'
    end
  end

  def constraint_params_to_mana_constraint(constraint_params)
    sub_params = constraint_params.second

    {
      sub_params['color'].to_sym => {
        count: sub_params['amount'].to_i,
        turn: sub_params['turn'].to_i
      }
    }
  end
end

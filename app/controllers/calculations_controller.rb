class CalculationsController < ApplicationController
  COLORS = %w(white blue black red green colorless).freeze

  ManaConstraint = Struct.new(:color, :count, :quantifier, :turn)

  def new
    @non_basic_lands = ManaSource.where(basic: false).alphabetized
    @colors = COLORS
    @amounts = (1..10).to_a
  end

  def create
    @mana_bases = CalculateManaBase.new(mana_constraints, lands_to_consider).call.first(10)
    render :show
  end

  private

  def lands_to_consider
    (params["non_basic_lands"] || []) + colors_desired.flat_map { |color| ManaSource.where(color.to_sym => true, :basic => true) }.pluck('name')
  end

  def mana_constraints
    calculation_params.map do |constraint_params|
      constraint_params_to_mana_constraint(constraint_params)
    end.sort_by { |constraint| COLORS.index(constraint.color) }
  end

  def calculation_params
    params['calculations'].delete_if do |key, _value|
      key == 'constraint_X'
    end
  end

  def colors_desired
    calculation_params.map do |constraint_params|
      constraint_params.second["color"]
    end
  end

  def constraint_params_to_mana_constraint(constraint_params)
    sub_params = constraint_params.second

    ManaConstraint.new(
      sub_params['color'].to_sym,
      sub_params['amount'].to_i,
      sub_params['quantifier'],
      sub_params['turn'].to_i
    )
  end
end

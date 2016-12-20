Rails.application.config.to_prepare do
  # profile_calc_method(:successful_mana_bases)
  # profile_calc_method(:possible_hands_for_mana_base)
  # profile_calc_method(:hands_with_required_mana_sources)
  # profile_calc_method(:possible_hands)
  # profile_calc_method(:satisfies_mana_requirements?)
  # profile_calc_method(:mana_base_combinations)
  profile_calc_method(:hasherize)
  # profile_calc_method(:amounts_desired)
  # profile_calc_method(:mana_sources_desired)
  # profile_calc_method(:non_mana_sources_desired)
end

def profile_calc_method(method)
  ::Rack::MiniProfiler.profile_method(CalculateManaBase, method) do |_a|
    "Executing method: CalculateManaBase##{method}"
  end
end

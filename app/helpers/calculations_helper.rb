module CalculationsHelper
  def mana_icon_for(color)
    content_tag(:i, '', class: "ms ms-cost ms-#{ManaSource::COLOR_IDENTITIES[color]}")
  end
end

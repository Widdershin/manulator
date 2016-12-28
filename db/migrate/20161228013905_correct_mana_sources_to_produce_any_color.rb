class CorrectManaSourcesToProduceAnyColor < ActiveRecord::Migration[5.0]
  def change
    transaction do
      sources = ManaSource.where(basic: false)

      sources.each do |source|
        card = MTG::Card.find(source.multiverse_id)
        produces_any_color = card.text.include?('Add one mana of any color')
        searches_for_basic = card.text.include?("Search your library for a basic land")

        if produces_any_color || searches_for_basic
          source.white, source.blue, source.black, source.red, source.green = true, true, true, true, true
        end

        unless source.save
          puts "\n\n******\n\nFailed to save mana source: #{source.name} because: #{source.errors.full_messages}\n\n******\n\n"
        end
      end
    end
  end
end

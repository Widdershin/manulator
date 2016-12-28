class PopulateManaSourcesWithMultiverseId < ActiveRecord::Migration[5.0]
  def up
    transaction do
      sources = ManaSource.all

      sources.each do |source|
        card = MTG::Card.where(name: source.name).all.select(&:multiverse_id).uniq(&:name).first
        source.multiverse_id = card.multiverse_id
        source.image_url = card.image_url

        unless source.save
          puts "\n\n******\n\nFailed to save mana source: #{source.name} because: #{source.errors.full_messages}\n\n******\n\n"
        end
      end
    end
  end

  def down
    ManaSource.where(basic: false).map do |ms|
      unless ms.destroy
        puts "\n\n******\n\nFailed to destroy mana source: #{ms.name} because: #{ms.errors.full_messages}\n\n******\n\n"
      end
    end
  end
end

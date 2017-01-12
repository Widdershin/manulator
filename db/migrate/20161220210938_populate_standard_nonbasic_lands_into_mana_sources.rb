class PopulateStandardNonbasicLandsIntoManaSources < ActiveRecord::Migration[5.0]
  COLOR_MAPPING = {
    'W' => :white,
    'U' => :blue,
    'B' => :black,
    'R' => :red,
    'G' => :green,
    'C' => :colorless
  }

  def up
    transaction do
      standard_lands = MTG::Card.where(gameFormat: 'Standard').where(type: 'Land').all

      standard_nonbasics = standard_lands.uniq(&:name).select { |land| land.supertypes.blank? }

      standard_nonbasics.each do |land|
        etb_tapped = land.text.include?('enters the battlefield tapped')
        colors = land.text.scan(/\{([WUBRGC])\}*/).map(&:first).uniq

        ms = ManaSource.new(name: land.name, basic: false, etb_tapped: etb_tapped, mtg_api_id: land.id)

        colors.each do |color|
          ms.send("#{COLOR_MAPPING[color]}=", true)
        end

        unless ms.save
          puts "\n\n******\n\nFailed to create mana source: #{ms.name} because: #{ms.errors.full_messages}\n\n******\n\n"
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

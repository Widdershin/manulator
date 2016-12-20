class PopulateBasicLandsIntoManaSources < ActiveRecord::Migration[5.0]
  NAME_TO_COLOR_MAPPING = {
    'Plains' => :white,
    'Island' => :blue,
    'Swamp' => :black,
    'Mountain' => :red,
    'Forest' => :green,
    'Waste' => :colorless
  }

  def up
    NAME_TO_COLOR_MAPPING.each do |name, color|
      ms = ManaSource.new(
        :name => name,
        :basic => true,
        :etb_tapped => false,
        color => true
      )

      unless ms.save
        puts "\n\n******\n\nFailed to create mana source: #{ms.name} because: #{ms.errors.full_messages}\n\n******\n\n"
      end
    end
  end

  def down
    ManaSource.where(name: NAME_TO_COLOR_MAPPING.keys).map do |ms|
      unless ms.destroy
        puts "\n\n******\n\nFailed to destroy mana source: #{ms.name} because: #{ms.errors.full_messages}\n\n******\n\n"
      end
    end
  end
end

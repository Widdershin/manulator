class AddMultiverseIdAndImageUrlToManaSource < ActiveRecord::Migration[5.0]
  def change
    add_column :mana_sources, :multiverse_id, :integer
    add_column :mana_sources, :image_url, :string
  end
end

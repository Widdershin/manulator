class AddMtgApiIdToManaSources < ActiveRecord::Migration[5.0]
  def change
    add_column :mana_sources, :mtg_api_id, :string
  end
end

class CreateManaSources < ActiveRecord::Migration[5.0]
  def change
    create_table :mana_sources do |t|
      t.string  :name,        null: false
      t.boolean :nonbasic,    null: false, default: false
      t.boolean :white,       null: false, default: false
      t.boolean :blue,        null: false, default: false
      t.boolean :black,       null: false, default: false
      t.boolean :red,         null: false, default: false
      t.boolean :green,       null: false, default: false
      t.boolean :colorless,   null: false, default: false
      t.boolean :etb_tapped,  null: false, default: false

      t.timestamps
    end
  end
end

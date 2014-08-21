class CreateMappings < ActiveRecord::Migration
  def change
    create_table :mappings do |t|
      t.string :locale, null: false
      t.string :localized_name, null: false
      t.string :osm_key
      t.string :osm_value
      t.boolean :plural
      t.string :operator
      t.timestamps
    end
  end
end

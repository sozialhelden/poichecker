class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.belongs_to :data_set
      t.integer :original_id
      t.column :osm_id, :bigint # Needs to be large as in osm are 64bit int ids
      t.string :osm_key
      t.string :osm_value
      t.string :name
      t.float :lat
      t.float :lon
      t.string :street
      t.string :housenumber
      t.string :postcode
      t.string :city
      t.string :country
      t.string :website
      t.string :phone
      t.string :wheelchair

      t.timestamps
    end
  end
end

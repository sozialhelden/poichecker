class CreateCandidates < ActiveRecord::Migration
  def up
    create_table :candidates, force: true do |t|
      t.belongs_to :place

      t.float :lat
      t.float :lon
      t.string :name
      t.string :housenumber
      t.string :street
      t.string :postcode
      t.string :city
      t.string :website
      t.string :phone
      t.string :wheelchair
      t.integer :osm_id
      t.string :osm_type

      t.timestamps
    end
    change_column :candidates, :osm_id, :bigint
  end

  def down
    drop_table :candidates
  end
end

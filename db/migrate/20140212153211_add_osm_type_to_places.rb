class AddOsmTypeToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :osm_type, :string
  end
end

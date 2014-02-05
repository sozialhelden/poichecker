class RemoveOsmKeyAndOsmValueFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :osm_key, :string
    remove_column :places, :osm_value, :string
  end
end

class AddWheelchairDescriptionToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :wheelchair_description, :string
    add_column :places, :wheelchair_toilet, :string
    add_column :places, :centralkey, :string
  end
end

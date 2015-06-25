class AddWheelchairDescriptionToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :wheelchair_description, :string
    add_column :candidates, :wheelchair_toilet, :string
    add_column :candidates, :centralkey, :string

  end
end

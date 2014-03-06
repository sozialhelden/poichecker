class AddDistanceToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :dist, :integer, default: 0
  end
end

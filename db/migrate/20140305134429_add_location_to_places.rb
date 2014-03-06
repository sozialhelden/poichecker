class AddLocationToPlaces < ActiveRecord::Migration
  def change
    change_table :places do |t|
      t.column :location, :point, spatial: true
      t.index :location, spatial: true
    end
  end
end

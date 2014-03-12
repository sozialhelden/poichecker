class AddLocationToPlaces < ActiveRecord::Migration
  def change
    change_table :places do |t|
      t.column :location, :point, geographic: true
      t.index :location, spatial: true
    end
  end
end

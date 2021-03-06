class CreateChangesets < ActiveRecord::Migration
  def change
    create_table :changesets, force: true do |t|
      t.column  :osm_id,        :bigint, null: false # Needs to be large as in osm are 64bit int ids
      t.references  :admin_user, null: false, index: true
      t.references  :data_set,   null: false, index: true
      t.timestamps
    end
  end
end

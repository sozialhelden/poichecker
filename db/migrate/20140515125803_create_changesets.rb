class CreateChangesets < ActiveRecord::Migration
  def change
    create_table :changesets, id: false do |t|
      t.column     :osm_id,     :bigint, null: false # Needs to be large as in osm are 64bit int ids
      t.belongs_to :admin_user,          null: false
      t.belongs_to :data_set,            null: false
      t.timestamps
    end
  end
end

class CreateChangesets < ActiveRecord::Migration
  def change
    create_table :changesets do |t|
      t.column  :osm_id,        :bigint, null: false # Needs to be large as in osm are 64bit int ids
      t.column  :admin_user_id, :integer
      t.column  :data_set_id,   :integer
      t.timestamps
    end
  end
end

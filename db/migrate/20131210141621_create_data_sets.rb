class CreateDataSets < ActiveRecord::Migration
  def change
    create_table :data_sets do |t|
      t.string :name
      t.string :license

      t.timestamps
    end
  end
end

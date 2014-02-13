class AddDescriptionToDataSets < ActiveRecord::Migration
  def change
    add_column :data_sets, :description, :text
  end
end

class AddMatcherIdToPlace < ActiveRecord::Migration
  def change
    add_column :places, :matcher_id, :integer
  end
end

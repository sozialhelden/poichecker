class Place < ActiveRecord::Base
  has_many :skips
end

class AddSkipCounterToPlaces < ActiveRecord::Migration
  def up
    add_column :places, :skips_count, :integer, default: 0
    Place.find_each{|p| Place.reset_counters(p.id, :skips)}
  end

  def down
    remove_column :places, :skips_count
  end
end

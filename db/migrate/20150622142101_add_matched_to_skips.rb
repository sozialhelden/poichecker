class AddMatchedToSkips < ActiveRecord::Migration
  def change
    add_column :skips, :matched, :boolean, null: false, default: false
  end
end

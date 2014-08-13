class CreateSkips < ActiveRecord::Migration
  def change
    create_table :skips, force: true do |t|
      t.references :admin_user, index: true, null: false
      t.references :place,      index: true, null: false

      t.timestamps
    end
  end
end

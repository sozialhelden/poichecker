class AddLocationToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :location, :point, geographic: true
  end
end

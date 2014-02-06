class AddOsmUsernameToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :osm_username, :string
  end
end

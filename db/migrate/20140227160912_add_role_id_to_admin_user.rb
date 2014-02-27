class AddRoleIdToAdminUser < ActiveRecord::Migration
  def up
    add_column    :admin_users, :role_id, :integer
    remove_column :admin_users, :role
  end

  def down
    remove_column :admin_users, :role_id
    add_column    :admin_users, :role, :string
  end
end

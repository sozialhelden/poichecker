class AddChangesetIdToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :changeset_id, :bigint
  end
end

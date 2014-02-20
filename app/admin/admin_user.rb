# encoding: UTF-8
ActiveAdmin.register AdminUser do

  actions :all, :except => [:create]

  filter :email
  filter :osm_id
  filter :osm_username

  index :download_links => false do
    column :id
    column :email
    column :osm_id
    column :osm_username
    column :role
    column :current_sign_in_at
    default_actions
  end
end
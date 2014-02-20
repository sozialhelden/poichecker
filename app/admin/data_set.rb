# encoding: UTF-8
ActiveAdmin.register DataSet do
  decorate_with DataSetDecorator

  permit_params :name, :license, :description

  filter :name
  filter :license
  filter :description
  filter :created_at

  index :download_links => false do
    selectable_column
    column :id
    column :name
    column :license
    column :orte
    default_actions if current_admin_user.admin?

  end
end

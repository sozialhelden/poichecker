# encoding: UTF-8
ActiveAdmin.register DataSet do
  decorate_with DataSetDecorator

  permit_params :name, :license

  filter :name
  filter :license

  index :download_links => false do
    selectable_column
    column :id
    column :name
    column :license
    column :orte
    default_actions

  end
end

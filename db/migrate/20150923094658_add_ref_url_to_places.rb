class AddRefUrlToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :ref_url, :string
  end
end

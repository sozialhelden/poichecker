# == Schema Information
#
# Table name: places
#
#  id          :integer          not null, primary key
#  data_set_id :integer
#  original_id :integer
#  osm_id      :integer
#  name        :string(255)
#  lat         :float
#  lon         :float
#  street      :string(255)
#  housenumber :string(255)
#  postcode    :string(255)
#  city        :string(255)
#  country     :string(255)
#  website     :string(255)
#  phone       :string(255)
#  wheelchair  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  osm_type    :string(255)
#  matcher_id  :integer
#  location    :spatial          point, 4326
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place do
    data_set
    name "Testplace"
    wheelchair "yes"
    lat 52.0
    lon 13.0
  end
end

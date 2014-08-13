# == Schema Information
#
# Table name: candidates
#
#  id          :integer          not null, primary key
#  place_id    :integer
#  lat         :float
#  lon         :float
#  name        :string(255)
#  housenumber :string(255)
#  street      :string(255)
#  postcode    :string(255)
#  city        :string(255)
#  website     :string(255)
#  phone       :string(255)
#  wheelchair  :string(255)
#  osm_id      :integer
#  osm_type    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  osm_key     :string(255)
#  osm_value   :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence :osm_id do |n|
    n
  end

  factory :candidate do
    osm_id
    osm_type 'node'
    name "Testplace"
    wheelchair "yes"
    lat 52.0
    lon 13.0
    housenumber "23"
    street "a_street"
    postcode "42424"
    city "Turing"
    website "http://example.com"
    phone "+49 30 12345678"
  end
end

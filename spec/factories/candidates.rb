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

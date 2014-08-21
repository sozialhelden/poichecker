# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mapping do
    localized_name "Banken"
    locale "DE"
    osm_key "amenity"
    osm_value "bank"
    plural true
  end
end

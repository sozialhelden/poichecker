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
  end
end

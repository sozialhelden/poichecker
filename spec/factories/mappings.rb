# == Schema Information
#
# Table name: mappings
#
#  id             :integer          not null, primary key
#  locale         :string(255)      not null
#  localized_name :string(255)      not null
#  osm_key        :string(255)
#  osm_value      :string(255)
#  plural         :boolean
#  operator       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

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

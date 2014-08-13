# == Schema Information
#
# Table name: changesets
#
#  id            :integer          not null, primary key
#  osm_id        :integer          not null
#  admin_user_id :integer          not null
#  data_set_id   :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :changeset do
    osm_id 1
    admin_user
    data_set
  end
end

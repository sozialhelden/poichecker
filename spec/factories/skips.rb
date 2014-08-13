# == Schema Information
#
# Table name: skips
#
#  id            :integer          not null, primary key
#  admin_user_id :integer          not null
#  place_id      :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :skip do
    admin_user
    place
  end
end

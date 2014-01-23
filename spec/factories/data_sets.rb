# == Schema Information
#
# Table name: data_sets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  license    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_set do
    name "T-Punkte"
    license "CC-By-SA"
  end
end

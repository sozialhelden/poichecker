# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role, aliases: [:user_role] do
    name "user"
  end

  factory :admin_role, parent: :role do
    name "admin"
  end
end

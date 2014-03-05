# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  osm_id                 :integer
#  oauth_token            :string(255)
#  oauth_secret           :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  osm_username           :string(255)
#  changeset_id           :integer
#  role_id                :integer
#  location               :spatial          point, 0
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user, class: AdminUser, aliases: [:author] do
    osm_id
    oauth_token           "token"
    oauth_secret          "secret"
    email                 "tim@example.com"
    password              "a_password"
    password_confirmation "a_password"
    osm_username          "a_osm_username"
    association :role, factory: :user_role
    location              "POINT(13.39 52.51)"
  end

  factory :admin, :parent => :user do
    association :role, factory: :admin_role
  end
end

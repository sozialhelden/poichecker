# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :admin_user do
    osm_id
    oauth_token           "token"
    oauth_secret          "secret"
    email                 "tim@example.com"
    password              "a_password"
    password_confirmation "a_password"
    osm_username          "a_osm_username"
    role                  "admin"
  end
end

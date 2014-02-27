FactoryGirl.define do
  factory :comment, class: ActiveAdmin::Comment do
    author
    body "This is a highly intelligent comment here, which is worth memorizing!"
    namespace '/'
  end
end

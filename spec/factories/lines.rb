FactoryGirl.define do
  factory :line do
    name 'a new line'
    association :user, factory: :user
  end
end

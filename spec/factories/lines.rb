FactoryGirl.define do
  factory :line do
    name 'a new line'
    properties [{"name"=>"Title", "required"=>true}, {"name"=>"Advertiser", "required"=>true}]
    association :user, factory: :user
  end
end

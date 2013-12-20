# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :city do
    name "West Newton"
    state "Massachussets"
    country "United States"
    latitude 0
    longitude 0
  end
end

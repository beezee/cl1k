# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :click do
    redirect_id 1
    user_agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36"
    browser ""
    version ""
    platform ""
    latitude ""
    longitude ""
    ip_address "96.230.46.15"
    city_id 1
  end
end

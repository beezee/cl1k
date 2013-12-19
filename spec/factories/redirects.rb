# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	sequence :slug do |n|
		"url-#{n}"
	end

	sequence :target do |n|
		"http://www.example.com/page/#{n}"
	end

  factory :redirect do
    target
    slug
    user_id 1
  end
end

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password 'password'
    authority '2'
    confirmed true
  end

  factory :company do
    name  { Faker::Company.name }
    goal_amount 1000000
    description { Faker::Lorem.paragraph }

  end

  factory :campaign do
    tagline {Faker::Company.catch_phrase }

    elevator_pitch { Faker::Lorem.paragraph }
    about_campaign { Faker::Lorem.paragraph }
    employees_numer { Faker::Config.random }

    state_where_incorporated { Faker::Address.state_abbr }
    company_location_address {Faker::Address.street_address}
    company_location_state { Faker::Address.state_abbr }
    company_location_city { Faker::Address.city }
    company_location_zipcode { Faker::Address.zip_code }
  end
end

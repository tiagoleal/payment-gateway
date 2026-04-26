FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email_address { Faker::Internet.email }
    password { "password" }
  end

  factory :user_register, class: "User" do
    name { Faker::Name.name }
    email_address { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
  end
end

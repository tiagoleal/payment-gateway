FactoryBot.define do
  factory :client do
    name        { Faker::Name.name }
    due_day     { rand(1..28) }
    payment_method_identifier { [ "credit_card", "boleto" ].sample }
  end
end

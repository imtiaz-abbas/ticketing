FactoryBot.define do
  factory :show do
    date { Faker::Time.forward(days: 2, period: :afternoon) }
  end
end

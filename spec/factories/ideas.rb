FactoryBot.define do
  factory :idea do
    association :category
    body { "MyText" }
  end
end

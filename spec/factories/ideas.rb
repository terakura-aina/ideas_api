FactoryBot.define do
  factory :idea do
    association :category
    body { "idea_1" }

    trait :other_idea do
      association :category, :other_category
      body { "idea_2" }
    end
  end
end

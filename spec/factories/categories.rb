FactoryBot.define do
  factory :category do
    name { "category_1" }
  end

  trait :other_category do
    name { "category_2" }
  end
end

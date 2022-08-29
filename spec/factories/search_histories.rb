FactoryBot.define do
  factory :search_history do
    query { Faker::Movie.title }
    view_count { 1 }
  end
end

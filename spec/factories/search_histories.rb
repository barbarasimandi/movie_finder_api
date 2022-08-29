FactoryBot.define do
  factory :search_history do
    query { "MyString" }
    page { 1 }
  end
end

FactoryBot.define do
  factory :movie do
    title { Faker::Movie.title }
    overview { Faker::Lorem.paragraph }
    sequence(:poster_path) { |n| Faker::Internet.url(host: 'example.com', path: n.to_s) }
    release_date { Faker::Date.between(from: '1900-01-01', to: '2022-08-29').to_s }
    vote_average { Faker::Number.between(from: 0.0, to: 10.0).round(1) }
    sequence(:tmdb_id)
  end
end

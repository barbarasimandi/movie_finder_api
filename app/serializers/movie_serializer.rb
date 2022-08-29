class MovieSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :overview, :poster_path, :vote_average

  attribute :release_year do |movie|
    movie.release_date.slice(0, 4)
  end

  attribute :genre_names do |object|
    object.genres.map(&:name).join(", ")
  end
end

class MovieSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :overview, :release_date, :poster_path, :vote_average

  attribute :genre_names do |object|
    object.genres.map(&:name).join(", ")
  end
end

class Movie < ApplicationRecord
  has_and_belongs_to_many :genres

  validates_uniqueness_of :tmdb_id

  def self.find_or_create_from(params)
    existing_movie = find_by(tmdb_id: params[:id])

    if existing_movie
      Rails.logger.warn("Returned from database")
      existing_movie
    else
      Rails.logger.warn("Returned from api")
      create(
        title: params[:title],
        overview: params[:overview],
        poster_path: params[:poster_path],
        release_date: params[:release_date],
        vote_average: params[:vote_average],
        tmdb_id: params[:id],
        genres: Genre.where(tmdb_id: params[:genre_ids])
      )
    end
  end
end

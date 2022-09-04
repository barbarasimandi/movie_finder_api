require 'movies_client'

class MovieHandler < ApplicationService
  attr_reader :search, :page

  def initialize(options = {})
    @search = options[:search]
    @page = options[:page].to_i.zero? ? 1 : options[:page].to_i
  end

  def call
    find_or_create_movies
  end

  private

  def find_or_create_movies
    response = MoviesClient.search(search, page)
    return { errors: response[:errors] } if response[:errors].present?

    movies = response[:results].map do |tmdb_params|
      Movie.find_by(tmdb_id: tmdb_params[:id]) || Movie.create_from(tmdb_params)
    end

    MovieSerializer.new(movies).serializable_hash.merge(total_pages: response.fetch(:total_pages, 0))
  end
end

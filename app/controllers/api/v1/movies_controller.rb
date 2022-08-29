require 'movies_client'

module Api
  module V1
    class MoviesController < ApplicationController
      def index
        response = MoviesClient.search(params[:search], params.fetch(:page, 1))

        if response[:errors].any?
          render json: response[:errors]
        else
          movies = Rails.cache.fetch(cache_key) do
            response[:results].map do |movie_params|
              Movie.find_or_create_from(movie_params)
            end
          end

          render json: MovieSerializer.new(movies).serializable_hash.merge(total_pages: response[:total_pages])
        end
      end

      private

      def cache_key
        "#{params[:search]}/#{params.fetch(:page, 1)}"
      end

    end
  end
end

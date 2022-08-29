require 'movies_client'

module Api
  module V1
    class MoviesController < ApplicationController
      def index
        handle_search_history

        response = MoviesClient.search(params[:search], params.fetch(:page, 1))

        if response[:errors].any?
          render json: response[:errors]
        else
          if Rails.cache.read(cache_key)
            movies = Rails.cache.read(cache_key)
          else
            movies = response[:results].map do |movie_params|
              Movie.find_or_create_from(movie_params)
            end

            Rails.cache.write(cache_key, movies)
          end
          render json: MovieSerializer.new(movies).serializable_hash.merge(total_pages: response[:total_pages])
        end
      end

      private

      def cache_key
        "#{params[:search]}/#{params.fetch(:page, 1)}"
      end

      def handle_search_history
        search_history = SearchHistory.find_by(query: params[:search])

        if search_history && params[:page].to_i.zero?
          search_history.increment!(:view_count)
        elsif params[:search].present? && search_history.nil?
          SearchHistory.create(query: params[:search])
        end
      end
    end
  end
end

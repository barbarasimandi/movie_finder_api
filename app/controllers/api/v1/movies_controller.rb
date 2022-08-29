require 'movies_client'

module Api
  module V1
    class MoviesController < ApplicationController
      def index
        response = MoviesClient.search(params[:search], params.fetch(:page, 1))

        if response[:errors].any?
          render json: response[:errors]
        else
          @movies = response[:results].map do |movie_params|
            Movie.create_from(movie_params)
          end
          render json: @movies
        end
      end
    end
  end
end

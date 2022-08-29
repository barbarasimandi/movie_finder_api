require 'movies_client'

module Api
  module V1
    class MoviesController < ApplicationController
      def index
        response = MoviesClient.search(params[:search], params.fetch(:page, 1))

        if response[:results].any?
          @movies =  response[:results].map do |movie_params|
            Movie.create_from(movie_params)
          end
          render json: @movies
        else
          render json: response[:errors]
        end
      end
    end
  end
end


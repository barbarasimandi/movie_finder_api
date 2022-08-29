require 'movies_client'

module Api
  module V1
    class MoviesController < ApplicationController
      def index
        SearchHistoryHandler.new(params[:search], params[:page]).call

        movies_response = Rails.cache.fetch(cache_key) do
          MovieHandler.new(params[:search], params[:page]).call
        end

        render json: movies_response
      end

      private

      def cache_key
        "#{params[:search]}/#{params.fetch(:page, 0)}"
      end
    end
  end
end
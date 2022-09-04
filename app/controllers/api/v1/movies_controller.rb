module Api
  module V1
    class MoviesController < ApplicationController
      def index
        SearchHistoryHandler.call(search_params)

        movies_response = Rails.cache.fetch(cache_key) do
          MovieHandler.call(search_params)
        end

        render json: movies_response
      end

      private

      def cache_key
        "#{params[:search]}/#{params.fetch(:page, 0)}"
      end

      def search_params
        params.permit(:search, :page)
      end
    end
  end
end

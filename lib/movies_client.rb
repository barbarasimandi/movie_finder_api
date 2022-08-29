require "uri"
require "net/http"

class MoviesClient
  BASE_URL = "https://api.themoviedb.org".freeze
  API_VERSION = 3

  class << self
    def fetch_genres
      response = get(genres_url)
      handle_response(response)
    end

    def search(query, page)
      response = get(search_url(query, page))
      handle_response(response)
    end

    def get(url)
      uri = URI(url)
      Net::HTTP.get_response(uri, headers)
    end

    def genres_url
      "#{BASE_URL}/#{API_VERSION}/genre/movie/list"
    end

    def search_url(query, page)
      "#{BASE_URL}/#{API_VERSION}/search/movie?query=#{query}&page=#{page}"
    end

    private

    # TODO: handle 500 errors and no matching movies
    def handle_response(response)
      json = JSON.parse(response.body, symbolize_names: true)

      if response.code == "200"
        json.merge(errors: [])
      elsif %w[401 404].include?(response.code)
        fallback_response.merge(errors: json[:status_message])
      else
        fallback_response.merge(errors: json[:errors])
      end
    end

    def fallback_response
      {
        results: [],
        total_pages: 0
      }
    end

    def headers
      {
        'Content-Type' => 'application/json;charset=utf-8',
        'Authorization' => bearer_token
      }
    end

    def bearer_token
      File.read(Rails.root.join("config", ".bearer"))
    end
  end
end

require "uri"
require "net/http"

class MoviesClient
  BASE_URL = "https://api.themoviedb.org".freeze
  API_VERSION = 3

  class << self
    def fetch_genres
      response = get(genres_url)
      JSON.parse(response.body, symbolize_names: true)
    end

    def get(url)
      uri = URI(url)
      Net::HTTP.get_response(uri, headers)
    end

    def genres_url
      "#{BASE_URL}/#{API_VERSION}/genre/movie/list"
    end

    private

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

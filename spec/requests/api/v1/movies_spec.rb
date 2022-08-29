require 'rails_helper'

RSpec.describe "Api::V1::Movies", type: :request do
  describe "GET /api/v1/movies" do
    let!(:movie) { FactoryBot.create(:movie) }

    context "without query params" do
      it "returns http success" do
        get api_v1_movies_path
        expect(response).to have_http_status(200)
      end
    end

    context "with query params" do
      before { get api_v1_movies_path params: params }

      context "with search param" do
        let(:params) { { search: movie.title } }

        it "returns http success" do
          expect(response).to have_http_status(200)
        end

        it "returns movies" do
          movies = JSON.parse(response.body, symbolize_names: true)
          expect(movies.first[:title]).to eq(movie.title)
        end
      end

      context "with search and page params" do
        let(:params) { { search: "The", page: 2 } }
        let(:first_movie_json) do
          {
            id: 2,
            title: "The Black Phone",
            overview: "Finney Blake, a shy but clever 13-year-old boy (...)",
            poster_path: "/lr11mCT85T1JanlgjMuhs9nMht4.jpg",
            release_date: "2022-06-22",
            vote_average: "7.9",
            tmdb_id: 756_999,
            created_at: "2022-08-29T17:19:58.514Z",
            updated_at: "2022-08-29T17:19:58.514Z"
          }
        end

        it "returns http success" do
          expect(response).to have_http_status(200)
        end

        it "returns second page of movies" do
          movies = JSON.parse(response.body, symbolize_names: true)
          expect(movies.first[:title]).not_to eq(first_movie_json[:title])
        end
      end
    end
  end
end

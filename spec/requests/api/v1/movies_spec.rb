require 'rails_helper'

RSpec.describe "Api::V1::Movies", type: :request do
  describe "GET /api/v1/movies" do
    let!(:movie) { FactoryBot.create(:movie) }
    let!(:search_history) { FactoryBot.create(:search_history, query: movie.title) }

    context "without query params" do
      it "returns http success" do
        get api_v1_movies_path
        expect(response).to have_http_status(200)
      end
    end

    context "with query params" do
      before { get(path, params: params) }

      context "with search param" do
        context "when results" do
          let(:path) { api_v1_movies_path }
          let(:params) { { search: movie.title } }

          it "returns http success" do
            expect(response).to have_http_status(200)
          end

          it "returns movies" do
            movies = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(movies.first[:attributes][:title].downcase).to eq(movie.title.downcase)
          end

          it "increments search_history's view_count" do
            10.times { get api_v1_movies_path params: params }
            expect(search_history.reload.view_count).to eq(12)
          end
        end

        context "when no results" do
          let(:path) { api_v1_movies_path }
          let(:params) { { search: "usvuesbvluiahj" } }

          it "returns http success" do
            expect(response).to have_http_status(200)
          end

          it "returns an empty array of data" do
            movies = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(movies).to be_empty
          end
        end
      end

      context "with search param" do
        context "when correct page params" do
          let(:path) { api_v1_movies_path }
          let(:params) { { search: "The", page: 2 } }
          let(:first_movie_json) do
            {
              id: "2",
              type: "movie",
              attributes: {
                title: "The Black Phone",
                overview: "Finney Blake, a shy but clever 13-year-old boy (...)",
                poster_path: "/lr11mCT85T1JanlgjMuhs9nMht4.jpg",
                vote_average: "7.9",
                release_year: "2022",
                genre_names: ""
              }
            }
          end

          it "returns http success" do
            expect(response).to have_http_status(200)
          end

          it "returns second page of movies" do
            movies = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(movies.first[:attributes][:title]).not_to eq(first_movie_json[:attributes][:title])
          end
        end

        context "when incorrect page params" do
          let(:path) { api_v1_movies_path }
          let(:params) { { search: "The", page: 501 } }

          it "returns an error message" do
            messages = JSON.parse(response.body, symbolize_names: true)[:errors]
            expect(messages).to include("page must be less than or equal to 500")
          end
        end
      end

      context "with empty search param, and correct page params" do
        let(:path) { api_v1_movies_path }
        let(:params) { { search: "", page: 1 } }

        it "doesn't return data array" do
          movies = JSON.parse(response.body, symbolize_names: true)
          expect(movies[:data]).to be_nil
        end

        it "returns errors" do
          movies = JSON.parse(response.body, symbolize_names: true)
          expect(movies[:errors]).to eq(["query must be provided"])
        end
      end
    end
  end
end

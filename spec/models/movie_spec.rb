require 'rails_helper'

RSpec.describe Movie, type: :model do
  subject(:movie) { FactoryBot.create(:movie) }

  describe "associations" do
    it "has_and_belongs_to_many :genres" do
      expect(movie).to have_and_belong_to_many(:genres)
    end
  end

  describe "validations" do
    it "validates_uniqueness_of :tmdb_id" do
      expect(movie).to validate_uniqueness_of(:tmdb_id)
    end
  end
end

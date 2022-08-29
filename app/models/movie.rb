class Movie < ApplicationRecord
  has_and_belongs_to_many :genres

  validates_uniqueness_of :tmdb_id
end

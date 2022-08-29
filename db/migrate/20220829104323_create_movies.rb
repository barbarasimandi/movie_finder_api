class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.boolean :adult
      t.integer :tmdb_id, index: { unique: true, name: 'unique_tmdb_id' }
      t.string :title
      t.text :overview
      t.string :poster_path
      t.string :release_date
      t.decimal :vote_average
      t.integer :vote_count

      t.timestamps
    end
  end
end

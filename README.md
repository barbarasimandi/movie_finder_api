# Movie Finder

This is the backend part of my movie finder. You can find the frontend part [here](https://github.com/barbarasimandi/movie_finder_web).
The application's goal is to display movies based on a search.

## Getting started

### 1. Bearer token 
   - The application uses The Movie Database API to retrieve movies. 
   - For having a Bearer token, see [v4 auth](https://www.themoviedb.org/settings/api).
   - In order to access the API, you need the token saved to a `.bearer` file, in config/ directory.

### 2. Genres
   - The Movie Database API works with a small set of genres associated to the movies.
   - In order to save the same data to the app's database, in the application's root directory run:
```
rake db:create
rake db:migrate
```
- followed by
```
rake db:seed
```

### 3. Start the servers
- In you console run `rails s -p 4000` from the movie_finder_api's directory, and
- on another tab run `npm install` and `npm start` from the movie_finder_web's directory.

class MoviesController < ApplicationController
  def index
    # Query: Retrieves movie records from the database.
    # Ordering: Sorts movies by release year (newest to oldest) and then by title (alphabetically).
    @movies = Movie.order(year: :desc, title: :asc)

    # Verifies if a search query is provided in the incoming request.
    # If a query exists, filters movie records by title, matching the query string in a case-insensitive manner.
    if params[:query].present?
      @movies = @movies.where("title ILIKE ?", "%#{params[:query]}%")
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "movies/list", locals: {movies: @movies}, formats: [:html] }
    end
  end

  def update
    @movie = Movie.find(params[:id])
    @movie.update(movie_params)

    respond_to do |format|
      format.html { redirect_to movies_path }
      format.text { render partial: "movies/movie_infos", locals: {movie: @movie}, formats: [:html] }
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :year)
  end

end

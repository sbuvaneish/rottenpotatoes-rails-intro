class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # When the reset_session variable is set (through the Reset Session link), the session is cleared.
    if !params[:reset_session].nil?
      session.clear
    end
    
    # Session key values are changed depending on whether those parameters are set in the get request.
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    
    if !params[:sort].nil?
      session[:sort] = params[:sort]
    end
    
    # Picks the list of ratings from the Movie model.
    @all_ratings = Movie.all_ratings
    
    # Uses the ratings and sort information available in sessions to render the index page.
    if !session[:ratings].nil?
      @movies = Movie.with_ratings(session[:ratings].keys)
    else
      @movies = Movie.all
    end
    
    if !session[:sort].nil?
      @movies = @movies.order(session[:sort])
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

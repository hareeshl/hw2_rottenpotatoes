class MoviesController < ApplicationController

  def show        
    id = params[:id] 
    if id =~ /^title$/      
      flash[:issorted] = 'title'            
      redirect_to movies_path
    elsif id =~ /^release_date$/
      flash[:issorted] = 'release_date'            
      redirect_to movies_path
    else
      @movie = Movie.find(id)    
    end
  end

  def index
    if flash[:issorted] =~ /^title$/    
      @movies = Movie.find(:all, :order=>'title')  
    elsif flash[:issorted] =~ /^release_date$/    
      @movies = Movie.find(:all, :order=>'release_date')
    else
      @movies = Movie.all      
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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

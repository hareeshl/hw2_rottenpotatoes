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

    @all_ratings = Movie.group(:rating)
    
    unless params[:ratings].nil?
      session[:selected_ratings] = params[:ratings]
    end
    
    if flash[:issorted] =~ /^title$/ 
      if session[:selected_ratings].nil?
        @movies = Movie.find(:all,:order=>'title')
      else
        @movies = Movie.find_all_by_rating(session[:selected_ratings].keys, :order=>'title').each do |movieWithRating|
          @all_ratings.each do |rating|
            if rating == movieWithRating
                rating.isChecked = true
            end
          end  
        end
      end        
    elsif flash[:issorted] =~ /^release_date$/ 
      if session[:selected_ratings].nil?
        @movies = Movie.find(:all,:order=>'release_date')
      else
        @movies = Movie.find_all_by_rating(session[:selected_ratings].keys, :order=>'release_date').each do |movieWithRating|
          @all_ratings.each do |rating|
            if rating == movieWithRating
                rating.isChecked = true
                puts rating.title
            end
          end 
        end 
      end
    else
       if params[:ratings].nil?
          @movies = Movie.all
          session[:selected_ratings] = nil
       else
          @movies = Movie.find_all_by_rating(session[:selected_ratings].keys).each do |movieWithRating|
            @all_ratings.each do |rating|
              if rating == movieWithRating
                rating.isChecked = true
              end
            end 
          end
       end      
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

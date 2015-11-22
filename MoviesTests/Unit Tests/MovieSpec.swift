 //
 //  MovieSpec.swift
 //  Movies
 //
 //  Created by EastAgile16 on 10/27/15.
 //  Copyright © 2015 EastAgile16. All rights reserved.
 //
 
 import Quick
 import Nimble
 import SwiftyJSON
 
 @testable import Movies
 
 class MovieSpec: MoviesSpec {
  override func spec() {
    super.spec()
    
    var movie: Movie!
    let json = MoviesTests.createMovieJSON()
    var movies: [Movie]!
    
    describe("#init") {
      context("new movie with short detail") {
        beforeEach {
          movie = Movie(json: json, isFull: false)
        }
        
        it("creates Inside Out movie with short detail") {
          self.expectShortDetailMovie(movie)
        }
      }
      
      context("new movie with full detail") {
        beforeEach {
          movie = Movie(json: json, isFull: true)
        }
        
        it("creates Inside Out movie with full detail") {
          self.expectFullDetailMovie(movie)
        }
      }
    }
    
    describe(".moviesWithArray") {
      beforeEach {
        movies = Movie.moviesWithArray([json, json])
      }
      
      it("creates list of movies with 2 movies") {
        expect(movies.count).to(equal(2))
        for movie in movies {
          expect(movie.title).to(equal("Inside Out"))
        }
      }
    }
  }
 }
 
 // MARK: - Test Details
 extension MovieSpec {
  
  func expectShortDetailMovie(movie: Movie) {
    expect(movie.originalId).to(equal(150540))
    expect(movie.title).to(equal("Inside Out"))
    expect(movie.thumbnailPoster).to(equal("\(MovieClient.baseImageUrl)w300/aAmfIX3TT40zUHGcCKrlOZRKC7u.jpg"))
    expect(movie.originalPoster).to(equal("\(MovieClient.baseImageUrl)original/aAmfIX3TT40zUHGcCKrlOZRKC7u.jpg"))
    expect(movie.releaseYear).to(equal("2015"))
    expect(movie.releaseDateString).to(equal("2015-06-19"))
    expect(movie.releaseDateFormat).to(equal("June 2015"))
  }
  
  func expectFullDetailMovie(movie: Movie) {
    expectShortDetailMovie(movie)
    expect(movie.overview).to(equal("Growing up can be a bumpy road, and it's no exception for Riley"))
    expect(movie.voteAverage).to(equal(8.2))
  }
  
 }
 
//
//  ReviewSpec.swift
//  Movies
//
//  Created by EastAgile16 on 11/3/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SwiftyJSON

@testable import Movies

class ReviewSpec: MoviesSpec {
  override func spec() {
    super.spec()
    
    var movie: Movie!
    var review: Review!
    let json: JSON = ["author": "Fatota", "content": "This is the most incredible movie I've ever seen :)"]
    var reviews: [Review]!
    
    beforeEach {
      movie = MoviesTests.createMovie(isFull: false)
    }
    
    describe("#init") {
      beforeEach {
        review = Review(json: json, movie: movie)
      }
      
      it("creates Inside Out's review") {
        self.expectReview(review)
      }
    }
    
    describe(".reviewsWithArray") {
      beforeEach {
        reviews = Review.reviewsWithArray([json, json], movie: movie)
      }
      
      it("creates list of reviews with 2 reviews") {
        expect(reviews.count).to(equal(2))
        for review in reviews {
          expect(review.author).to(equal("Fatota"))
        }
      }
    }
  }
}

// MARK: - Test Details
extension ReviewSpec {
  func expectReview(review: Review) {
    expect(review.author).to(equal("Fatota"))
    expect(review.content).to(equal("This is the most incredible movie I've ever seen :)"))
  }
}

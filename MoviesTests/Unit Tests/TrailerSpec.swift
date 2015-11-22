//
//  TrailerSpec.swift
//  Movies
//
//  Created by EastAgile16 on 10/27/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import Movies

class TrailerSpec: MoviesSpec {
  override func spec() {
    super.spec()
    
    var movie: Movie!
    var trailer: Trailer!
    let json: JSON = ["name": "Inside Out Trailer 2", "key": "_MC3XuMvsDI"]
    var trailers: [Trailer]!
    
    beforeEach {
      movie = MoviesTests.createMovie(isFull: false)
    }
    
    describe("#init") {
      beforeEach {
        trailer = Trailer(json: json, movie: movie)
      }
      
      it("creates Inside Out's trailer") {
        self.expectTrailer(trailer)
      }
    }
    
    describe(".trailersWithArray") {
      beforeEach {
        trailers = Trailer.trailersWithArray([json, json], movie: movie)
      }
      
      it("creates list of trailers with 2 trailers") {
        expect(trailers.count).to(equal(2))
        for trailer in trailers {
          expect(trailer.key).to(equal("_MC3XuMvsDI"))
        }
      }
    }
  }
}

// MARK: - Test Details
extension TrailerSpec {
  func expectTrailer(trailer: Trailer) {
    expect(trailer.name).to(equal("Inside Out Trailer 2"))
    expect(trailer.key).to(equal("_MC3XuMvsDI"))
    expect(trailer.youTubeUrl).to(equal("youtube://_MC3XuMvsDI"))
    expect(trailer.safariUrl).to(equal("https://youtu.be/_MC3XuMvsDI"))
    expect(trailer.thumbnailUrl).to(equal("http://img.youtube.com/vi/_MC3XuMvsDI/0.jpg"))
  }
}


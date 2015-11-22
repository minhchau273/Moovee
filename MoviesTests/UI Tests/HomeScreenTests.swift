//
//  HomeScreenTests.swift
//  Movies
//
//  Created by EastAgile16 on 11/4/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import KIF
import OHHTTPStubs

class HomeScreenTests: MoviesTestCase {
  
  override func beforeAll() {
    super.beforeAll()
    tester.loginIfNeeded()
  }
  
  // Test load Popular movies, show "Inside Out" movie
  func testLoadPopularMovies() {
    tester.waitForViewWithAccessibilityLabel("INSIDE OUT (2015)")
  }
  
  // Test change to Most Rated tab, show "Band of Brothers" movie
  func testChangeToMostRatedTab() {
    tester.tapMostRated()
  }
  
}

// MARK: - Test Details
extension KIFUITestActor {
  func tapMostRated() {
    OHHTTPStubs.stubFetchMostRatedMoviesRequest(page: 1)
    tapViewWithAccessibilityLabel("Most Rated")
    waitForViewWithAccessibilityLabel("BAND OF BROTHERS (2001)")
  }
}

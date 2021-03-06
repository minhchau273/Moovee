//
//  MoviesTestCase.swift
//  Movies
//
//  Created by EastAgile16 on 11/4/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import KIF
import OHHTTPStubs

class MoviesTestCase: KIFTestCase {
  override func beforeEach() {
    super.beforeEach()
    OHHTTPStubs.stubFetchBaseImageUrlRequest()
    OHHTTPStubs.stubFetchPopularMoviesRequest(page: 1)
    tester.backToHomeView()
  }
}

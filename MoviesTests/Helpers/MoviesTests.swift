//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Foundation
import SwiftyJSON

@testable import Movies

let insideOutId = 150540
let bandOfBrothersId = 331214

class MoviesTests {
  static func createMovieJSON() -> JSON {
    var json: JSON = ["id": insideOutId]
    json["overview"] = "Growing up can be a bumpy road, and it's no exception for Riley"
    json["poster_path"] = "/aAmfIX3TT40zUHGcCKrlOZRKC7u.jpg"
    json["release_date"] = "2015-06-19"
    json["title"] = "Inside Out"
    json["vote_average"] = 8.2
    return json
  }
  
  static func createMovie(isFull isFull: Bool) -> Movie {
    let json = createMovieJSON()
    return Movie(json: json, isFull: isFull)
  }
}

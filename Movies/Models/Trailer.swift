//
//  Trailer.swift
//  Movies
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Trailer: Object {
  dynamic var name = ""
  dynamic var key = ""
  dynamic var movie: Movie?
  
  override static func primaryKey() -> String? {
    return "key"
  }
  
  convenience init(json: JSON, movie: Movie) {
    self.init()
    name = json["name"].stringValue
    key = json["key"].stringValue
    self.movie = movie
  }
  
  static func trailersWithArray(array: [JSON], movie: Movie) -> [Trailer] {
    var trailers = [Trailer]()
    
    for json in array {
      trailers.append(Trailer(json: json, movie: movie))
    }
    
    return trailers
  }
}

// MARK: - Computed properties
extension Trailer {
  var youTubeUrl: String {
    return "youtube://" + key
  }
  
  var safariUrl: String {
    return "https://youtu.be/" + key
  }
  
  var thumbnailUrl: String {
    return "http://img.youtube.com/vi/\(key)/0.jpg"
  }
}

//
//  Review.swift
//  Movies
//
//  Created by EastAgile16 on 11/2/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Review: Object {
  dynamic var id = ""
  dynamic var author = ""
  dynamic var content = ""
  dynamic var movie: Movie?
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  convenience init(json: JSON, movie: Movie) {
    self.init()
    id = json["id"].stringValue
    author = json["author"].stringValue
    content = json["content"].stringValue
    self.movie = movie
  }
  
  static func reviewsWithArray(array: [JSON], movie: Movie) -> [Review] {
    var reviews = [Review]()
    
    for json in array {
      reviews.append(Review(json: json, movie: movie))
    }
    
    return reviews
  }
  
}

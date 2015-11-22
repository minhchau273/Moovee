//
//  Movie.swift
//  Movies
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Movie: Object {
  dynamic var id = 0
  dynamic var title = ""
  dynamic var lowResolutionPoster = ""
  dynamic var thumbnailPoster = ""
  dynamic var originalPoster = ""
  dynamic var posterLocalPath = ""
  dynamic var releaseDate: NSDate?
  dynamic var overview = ""
  dynamic var voteAverage: Double = 0
  dynamic var totalReviewPages = 0
  dynamic var currentReviewPage = 0
  
  let trailers = List<Trailer>()
  let reviews = List<Review>()
  
  convenience init(json: JSON, isFull: Bool) {
    self.init()
    
    id = json["id"].intValue
    title = json["title"].stringValue
    
    if let posterPath = json["poster_path"].string {
      originalPoster = MovieClient.baseImageUrl + "original" + posterPath
      thumbnailPoster = MovieClient.baseImageUrl + "w300" + posterPath
      lowResolutionPoster = MovieClient.baseImageUrl + "w154" + posterPath
    }
    
    if let releaseDateString = json["release_date"].string {
      releaseDate = DateFormatter.yyyy_MM_dd.dateFromString(releaseDateString)
    }
    
    if isFull {
      overview = json["overview"].stringValue
      voteAverage = json["vote_average"].doubleValue
    }
  }
  
  static func moviesWithArray(array: [JSON]) -> [Movie] {
    var movies = [Movie]()
    
    for json in array {
      movies.append(Movie(json: json, isFull: false))
    }
    
    return movies
  }
}

// MARK: - Computed properties

extension Movie {
  var releaseYear: String {
    return releaseDate != nil ? DateFormatter.yyyy.stringFromDate(releaseDate!) : ""
  }
  
  var releaseDateString: String {
    return releaseDate != nil ? DateFormatter.yyyy_MM_dd.stringFromDate(releaseDate!) : ""
  }
  
  var releaseDateFormat: String {
    return releaseDate != nil ? DateFormatter.MMMM_yyyy.stringFromDate(releaseDate!) : ""
  }
}

// MARK: - RealmObject

extension Movie {
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  func save() {
    savePosterToDocumentsDirectory()
    
    let realm = try! Realm()
    try! realm.write {
      realm.add(self, update: true)
    }
  }
  
  func delete() {
    let realm = try! Realm()
    try! realm.write {
      realm.delete(self)
    }
  }
  
  static var allFavorites: [Movie] {
    return Array(try! Realm().objects(Movie))
  }
  
  static func getFavoriteMovieFromId(id: Int) -> Movie? {
    return Movie.allFavorites.filter({$0.id == id}).first
  }
  
}

// MARK: - Save poster to documents directory

extension Movie {
  
  func savePosterToDocumentsDirectory() {
    let imageUrl = NSURL(string: originalPoster)
    if let imageUrl = imageUrl,
      imageData = NSData(contentsOfURL: imageUrl),
      image = UIImage(data: imageData) {
        let localPath = getFileInDocumentsDirectory("\(id).jpg")
        if saveImage(image, path: localPath) {
          posterLocalPath = localPath
          print("path: \(posterLocalPath)")
        }
    }
  }
  
  func saveImage(image: UIImage, path: String) -> Bool {
    let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
    let result = jpgImageData!.writeToFile(path, atomically: true)
    return result
  }
  
  // Get the documents Directory
  func getDocumentsDirectory() -> String {
    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    return documentsFolderPath
  }
  
  // Get path for a file in the directory
  func getFileInDocumentsDirectory(filename: String) -> String {
    return (getDocumentsDirectory() as NSString).stringByAppendingPathComponent(filename)
  }
  
}

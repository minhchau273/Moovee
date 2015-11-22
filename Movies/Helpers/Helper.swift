//
//  Helper.swift
//  Movies
//
//  Created by EastAgile16 on 11/6/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Foundation
import ReachabilitySwift

class Helper {
  static func isTestMode() -> Bool {
    #if DEBUG
      if env("XCInjectBundle") != nil {
        return true
      }
    #endif
    return false
  }
  
  static func env(key: String) -> String? {
    let dict = NSProcessInfo.processInfo().environment
    return dict[key]
  }
  
  static func hasConnectivity() -> Bool {
    let reachability = try! Reachability.reachabilityForInternetConnection()
    let networkStatus: Int = reachability.currentReachabilityStatus.hashValue
    return networkStatus != 0
  }
  
}
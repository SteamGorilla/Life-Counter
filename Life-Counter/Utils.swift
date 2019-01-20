//
//  Utils.swift
//  Life-Counter
//
//  Created by Jeremy on 20/01/2019.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import Foundation

class Utils {
  
  static let sharedInstance = Utils()
  
  var data: [CounterModel] = [CounterModel(name: "Boire de l'eau", amount: 7),
                              CounterModel(name: "Bière", amount: 43)]
  
  let defaults = UserDefaults.standard
    
  var savedCounters: [CounterModel] {
    get {
      return defaults.object(forKey: "SavedCounters") as? [CounterModel] ?? [CounterModel]()
    }
    set {
      return defaults.set(data, forKey: "SavedCounters")
    }
  }
  
}

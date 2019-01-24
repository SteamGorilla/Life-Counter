//
//  Counter.swift
//  Life-Counter
//
//  Created by Jeremy on 20/01/2019.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import Foundation

struct CounterModel: Codable {
  var name: String
  var amount: Int
}

func saveUserDefaults(counters: [CounterModel]) {
  let defaults = UserDefaults.standard
  
  let jsonEncoder = JSONEncoder()
  let jsonData = try? jsonEncoder.encode(counters)
  
  defaults.set(jsonData, forKey: "savedCounters")
}

func loadUserDefaults() -> [CounterModel] {
  let defaults = UserDefaults.standard
  var savedCounters: [CounterModel] = []
  
  guard let jsonData = defaults.object(forKey: "savedCounters") as? Data else { return savedCounters}
  
  let jsonDecoder = JSONDecoder()
  savedCounters = try! jsonDecoder.decode([CounterModel].self, from: jsonData)
  
  return savedCounters
}

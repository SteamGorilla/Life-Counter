//
//  Counter.swift
//  Life-Counter
//
//  Created by Jeremy on 20/01/2019.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import Foundation

struct CounterModel {
  var name: String
  var amount: Int
}


class Counting: NSObject, NSCoding {
  var name: String
  var amount: Int
  
  
  init(name: String, amount: Int) {
    self.name = name
    self.amount = amount
    
  }
  
  required convenience init(coder aDecoder: NSCoder) {
    let name = aDecoder.decodeObject(forKey: "name") as! String
    let amount = aDecoder.decodeObject(forKey: "amount")
    self.init(name: name, amount: amount as! Int)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(amount, forKey: "amount")
  }
}

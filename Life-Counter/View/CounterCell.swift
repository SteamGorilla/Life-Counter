//
//  CounterCell.swift
//  Life-Counter
//
//  Created by Jeremy on 20/01/2019.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import UIKit

class CounterCell: UICollectionViewCell {
  
  //OUTLETS
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var btnLess: UIButton!
  @IBOutlet weak var btnMore: UIButton!
  
  var newAmount: Int?
  
  var amount = Dynamic<Int>(0)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.cornerRadius = 10.0
    
    self.contentView.isUserInteractionEnabled = false

  }
  
  public func configure(with model: CounterModel) {
    nameLabel.text = model.name
    amountLabel.text = String(model.amount)
  }
  
  @IBAction func lessBtnTapped(_ sender: Any) {
    newAmount = Int(amountLabel.text!)
    
    if (newAmount == 0) {
      amountLabel.text = "\(newAmount!)"
    } else {
      amountLabel.text = "\(newAmount! - 1)"
    }
    
    amount.value = newAmount!
  }
  
  
  @IBAction func moreBtnTapped(_ sender: Any) {
    newAmount = Int(amountLabel.text!)
    
    amountLabel.text = "\(newAmount! + 1)"
    
    amount.value = newAmount!
  }
  
  func sendNewAmount() -> Int {
    return newAmount!
  }
}

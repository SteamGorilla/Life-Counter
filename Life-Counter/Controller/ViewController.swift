//
//  ViewController.swift
//  Life-Counter
//
//  Created by Jeremy on 20/01/2019.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  var data: [CounterModel] = []
  
  var newLabelValue: String?
  var newAmountValue: Int?
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(UINib.init(nibName: "CounterCell", bundle: nil), forCellWithReuseIdentifier: "CounterCell")
    collectionView.backgroundColor = UIColor.clear
    collectionView.isUserInteractionEnabled = true
    
    prepareData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    saveUserDefaults(counters: data)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CounterCell", for: indexPath) as! CounterCell
    
    cell.amount.bindAndFire(self) { [weak self] amount in
      self!.data[indexPath.row].amount = amount
    }
    
    cell.configure(with: data[indexPath.row])
    
    return cell
  }
  
  func prepareData() {
    let isAlreadyLaunch: Bool = appDelegate.isAppAlreadyLaunchedOnce()
    
    if isAlreadyLaunch == true {
      data = loadUserDefaults()
    } else {
      data = []
    }
  }
  
  @IBAction func btnAddTapped(_ sender: Any) {
    let alert = UIAlertController(title: "Nouveau compteur", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Retour", style: .destructive, handler: nil)
    
    alert.addTextField { (textField) in
      textField.placeholder = "Chose que tu fais ?"
    }
    
    alert.addTextField { (textField) in
      textField.placeholder = "Combien ?"
      textField.keyboardType = UIKeyboardType.numberPad
    }
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
      let labelTextfield = alert!.textFields![0]
      let amountTextfield = alert!.textFields![1]
      
      self.newLabelValue = labelTextfield.text
      self.newAmountValue = Int(amountTextfield.text!)
      
      let newCounter: CounterModel = CounterModel(name: self.newLabelValue!, amount: self.newAmountValue!)
      
      self.data.append(newCounter)
      saveUserDefaults(counters: self.data)
      
      self.data = loadUserDefaults()

      self.collectionView.reloadData()
    }))
    
    alert.addAction(action)
    self.present(alert, animated: true)
  }
}


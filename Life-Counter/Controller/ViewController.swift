//
//  ViewController.swift
//  Life-Counter
//
//  Created by Jeremy on 20/01/2019.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
  var data: [CounterModel] = []
  
  var newLabelValue: String?
  var newAmountValue: Int?
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var bannerView: GADBannerView!
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(UINib.init(nibName: "CounterCell", bundle: nil), forCellWithReuseIdentifier: "CounterCell")
    collectionView.backgroundColor = UIColor.clear
    collectionView.isUserInteractionEnabled = true
    
    configureAdBanner()
    
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

    cell.configure(with: data[indexPath.row]) { incremented  in
      self.data[indexPath.row].amount += incremented ? 1 : -1
      saveUserDefaults(counters: self.data)
    }
    
    cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
    cell.deleteButton.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)
    
    cell.intelButton.layer.setValue(indexPath.row, forKey: "index")
    cell.intelButton.addTarget(self, action: #selector(showDate), for: .touchUpInside)
    
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
    let alert = UIAlertController(title: NSLocalizedString("new_counter", comment: ""), message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: NSLocalizedString("back", comment: ""), style: .destructive, handler: nil)
    
    alert.addTextField { (textField) in
      textField.placeholder =  NSLocalizedString("counter_name", comment: "")
    }
    
    alert.addTextField { (textField) in
      textField.placeholder =  NSLocalizedString("howmany", comment: "")
      textField.keyboardType = UIKeyboardType.numberPad
    }
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
      let labelTextfield = alert!.textFields![0]
      let amountTextfield = alert!.textFields![1]
      
      let dateFormat = DateFormatter()
      dateFormat.dateFormat = "dd-MM-yyyy"
      
      let now = dateFormat.string(from: Date())
      
      var newCounter: CounterModel = CounterModel(name: "", amount: 0, dateOfCreation: now)
      
      self.newLabelValue = labelTextfield.text
      self.newAmountValue = Int(amountTextfield.text!)
      
      if (self.newLabelValue == nil || self.newAmountValue == nil) {
        self.setAlertAction(message: NSLocalizedString("counter_empty", comment: ""))
        self.btnAddTapped(self)
      } else {
        newCounter = CounterModel(name: self.newLabelValue!, amount: self.newAmountValue!, dateOfCreation: now)
        
        self.data.append(newCounter)
        saveUserDefaults(counters: self.data)
        
        self.data = loadUserDefaults()
        
        self.collectionView.reloadData()
      }
    }))
    
    alert.addAction(action)
    self.present(alert, animated: true)
  }
  
  @objc func deleteUser(sender: UIButton) {
    
    let i: Int = (sender.layer.value(forKey: "index")) as! Int
    data.remove(at: i)
    
    saveUserDefaults(counters: data)
    collectionView.reloadData()
  }
  
  @objc func showDate(sender: UIButton) {
    
    let i: Int = (sender.layer.value(forKey: "index")) as! Int
    
    let alert = UIAlertController(title:  NSLocalizedString("counter_creation", comment: ""), message: "\(data[i].dateOfCreation)", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    alert.addAction(action)
    self.present(alert, animated: true)
  }
  
  func configureAdBanner() {
    
    bannerView.adUnitID = "ca-app-pub-5410400935274111/7400529402"
    bannerView.rootViewController = self
    
    bannerView.load(GADRequest())
  }
  
  func setAlertAction(message: String) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
      UIAlertAction in
      NSLog("OK Pressed")
    }
    
    alertController.addAction(okAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
}


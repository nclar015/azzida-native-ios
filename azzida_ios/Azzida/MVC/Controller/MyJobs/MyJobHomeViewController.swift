//
//  MyJobHomeViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 28/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import CarbonKit


class MyJobHomeViewController: UIViewController, CarbonTabSwipeNavigationDelegate{
    
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    let constant : CommonStrings = CommonStrings.commonStrings
    let userModel : UserModel = UserModel.userModel

    
    var itemslist : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        self.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: itemslist, delegate: self)
        self.carbonTabSwipeNavigation.insert(intoRootViewController: self)
        carbonTabSwipeNavigation.delegate = self
        self.style()
        userModel.JobType = "IN_PROGRESS"
        
        userModel.UserMainActivity = "MyJobHomeViewController"

    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.layoutIfNeeded()
      }
      
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
          self.navigationController?.navigationBar.shadowImage = nil
          self.navigationController?.navigationBar.layoutIfNeeded()
      }

    
    @objc func setText(){
      //  self.title = "My_Jobs".localized()
       // itemslist = ["ACTIVE".localized(), "COMPLETED".localized(), "CANCELED".localized()]
        itemslist = ["IN_PROGRESS".localized(), "COMPLETED".localized(), "CANCELED".localized()]
    }
    
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func style() {
        let colortext: UIColor  = UIColor.black
        carbonTabSwipeNavigation.toolbar.isTranslucent = true
        carbonTabSwipeNavigation.toolbar.barTintColor = constant.theamColor
        carbonTabSwipeNavigation.setIndicatorColor(colortext)
//        carbonTabSwipeNavigation.setTabExtraWidth(20)
       // carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(0.7))
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(1.0), font: UIFont.boldSystemFont(ofSize: 16))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white.withAlphaComponent(1.0), font: UIFont.boldSystemFont(ofSize: 16))
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.white)
        
        for index in 0...itemslist.count - 1{
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(self.view.frame.width/3, forSegmentAt: index)
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        return self.storyboard!.instantiateViewController(withIdentifier: "MyJobViewController") as!  MyJobViewController

    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
          if index == 0 {
              userModel.JobType = "IN_PROGRESS"
          }
          else if index == 1{
              userModel.JobType = "COMPLETED"
          }
          else{
              userModel.JobType = "CANCELED"
          }
      }
    
    
}

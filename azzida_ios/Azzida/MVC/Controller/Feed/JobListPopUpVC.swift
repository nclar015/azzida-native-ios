//
//  JobListPopUpVC.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 08/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class JobListPopUpVC: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let Constant : CommonStrings = CommonStrings.commonStrings
    var actionType = ""
    let userModel : UserModel = UserModel.userModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if actionType == "Thank_for_Applying"{
            
            //            if appDel.myListRquest == "Accept_Offer" {
            //                lblTitle.text = "Offer Accepted!"
            //                btnBack.setTitle("Back to Listing", for: .normal)
            //            }else{
            //                lblTitle.text = "Offer Not Accepted!"
            //                btnBack.setTitle("Back to Listing", for: .normal)
            //            }
            //
            lblTitle.text = "Thanks For Applying"
           // btnBack.setTitle("Back To Feed", for: .normal)
        }
            
        else if actionType == "Offer_Accepted"{
            lblTitle.text = "Offer Accepted!"
           // btnBack.setTitle("Back to Listing", for: .normal)
        }
        else if actionType == "Offer_Not_Accepted"{
            lblTitle.text = "Offer Not Accepted"
           // btnBack.setTitle("Back to Listing", for: .normal)
        }
        else{
            //            lblTitle.text = "Thanks For Applying!"
            //            btnBack.setTitle("Back To Feed", for: .normal)
        }
        
        
        if userModel.UserMainActivity == "HomeViewController"{
            self.btnBack.setTitle("Back To Feed", for: .normal)
            
        }
        
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "change_Request"), object: nil, userInfo: ["status":true])

        
    }
    
    
}

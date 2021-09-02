//
//  PayoutViewController.swift
//  Azzida
//
//  Created by Varun Naharia on 30/09/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class PayoutViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var txtAmount: RoundTextField!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var txtAccountNo: RoundTextField!
    
    var accountId:String = ""
    var amount:String = ""
    var userId:String = ""
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let userModel : UserModel = UserModel.userModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtAccountNo.text = accountId
        txtAmount.text = amount
    }
    

    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        let param = [
            "amount":self.amount,
            "accountnumber":self.accountId,
            "UserId":self.userId,
              "TokenUsed":AppTokenUsed.tokenUsed
        ]
        APIController().payout(params: param) { (response) in
            
            self.getUserProfile()
            
        }
    }
    
    func getUserProfile(){
        
        if appDel.user_ID == 0 {
            return
        }
        
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "UserId":appDel.user_ID
        ]
        apiController.getRequest(methodName: "GetProfile",param: param, isHUD: false) { (responce) in
            if responce["message"].stringValue == "success" {
                
                self.userModel.FirstName = responce["data"]["FirstName"].stringValue
                self.userModel.LastName = responce["data"]["LastName"].stringValue
                self.userModel.ProfilePicture = responce["data"]["ProfilePicture"].stringValue
                self.userModel.Id = responce["data"]["Id"].intValue
                self.userModel.RoleId = responce["data"]["RoleId"].intValue
                self.userModel.UserPassword =  responce["data"]["UserPassword"].stringValue
                self.userModel.UserEmail =  responce["data"]["UserEmail"].stringValue
                self.userModel.Skills =  responce["data"]["Skills"].stringValue
                self.userModel.DeviceId =  responce["data"]["DeviceId"].stringValue
                self.userModel.DeviceType =  responce["data"]["DeviceType"].stringValue
                self.userModel.UserName =  responce["data"]["UserName"].stringValue
                self.userModel.EmailType =  responce["data"]["EmailType"].stringValue
                self.userModel.UserRatingAvg = responce["data"]["UserRatingAvg"].doubleValue
                self.userModel.JobTypeCategory =  responce["data"]["JobType"].stringValue
                self.userModel.Balance = responce["data"]["Balance"].intValue
                self.userModel.RefCode = responce["data"]["RefCode"].stringValue
                self.userModel.accountNumber = responce["data"]["StripeAccId"].stringValue
                self.userModel.receivedAmount = responce["data"]["receivedAmount"].doubleValue
                self.userModel.azzidaVerified = responce["data"]["AzzidaVerified"].boolValue
                self.userModel.stripeAccId = responce["data"]["StripeAccId"].stringValue
                self.userModel.nationalStatus = responce["data"]["NationalStatus"].stringValue
                self.userModel.globalStatus = responce["data"]["GlobalStatus"].stringValue
                self.userModel.sexOffenderStatus = responce["data"]["SexOffenderStatus"].stringValue
                self.userModel.ssnTraceStatus = responce["data"]["SsnTraceStatus"].stringValue
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    Utilities.alert("Amount Added into Your Account")
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}

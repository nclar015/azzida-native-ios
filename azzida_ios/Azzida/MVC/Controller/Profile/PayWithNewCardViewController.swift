//
//  PayWithNewCardViewController.swift
//  Azzida
//
//  Created by iVishnu on 26/08/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import Stripe

class PayWithNewCardViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblPaymentMsg: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtExpiry: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var btnSaveCard: UIButton!
    
    var PaymentType = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var jobId = 0
    var amount = ""
    let userModel : UserModel = UserModel.userModel
    var expMonth = ""
    var expYear = ""
    var ToUserId = 0
    var FromViewController = ""
    var StrpiToken = ""
    var delegate : PaymentNewCardForOfferAccept! = nil
    var selectedPromoJson:JSON!
    var promoCode = ""
    var amountStrFinal = ""
    var feedJsonFinal = 0
    var tipIdFinal = "0"
    var tipFinal = Double()
    var ratingstrFinal = ""
    var paymentIdFinal = ""
    var emptyStringForApilink = ""
    var feedJsonSeekerID = 0
    var tokenValue :String!
    var strAmount = ""
    var strAmount1 = ""
    var paymentMsg = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.delegate = self
        txtCVV.keyboardType = .numberPad
        txtExpiry.keyboardType = .numberPad
        txtNumber.keyboardType = .numberPad
        
        txtNumber.delegate = self
        txtNumber.maxLength = 20
        txtCVV.delegate = self
        txtCVV.maxLength = 3
        txtExpiry.delegate = self
        txtExpiry.maxLength = 5
        if traitCollection.userInterfaceStyle == .dark{
            self.view.backgroundColor = .black
            self.txtName.backgroundColor = UIColor.black
            self.txtName.layer.borderColor = UIColor.white.cgColor
            self.btnSaveCard.setTitleColor(UIColor.white, for: .normal)
        }
        if paymentMsg == "true"{
            lblPaymentMsg.isHidden = false
        }else{
            lblPaymentMsg.isHidden = true
        }

    }
    
    func Valid()->Bool{
        if (txtName.text?.isEmpty)!{
            Alert.alert(message: "", title: "Please_enter_card_holder_name".localized())
            return false
        }
        if (txtNumber.text?.isEmpty)!{
            Alert.alert(message: "", title: "Please_enter_card_number".localized())
            return false
        }
        if (txtExpiry.text?.isEmpty)! || txtExpiry.text!.count < 5{
            Alert.alert(message: "", title: "Please_enter_card_expiry".localized())
            return false
        }
        if (txtCVV.text?.isEmpty)!{
            Alert.alert(message: "", title: "Please_enter_card_CVV".localized())
            return false
        }
        return true
    }
    
    
    func getValidExpiry(text:String)->(String,String){
        
        let expiryString = text.components(separatedBy: "/")
        let month = "\(expiryString[0])"
        let year = "\(expiryString[1])"
        return(month,year)
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPay(_ sender: UIButton) {
        
        if !Valid(){
            return
        }
         let v = CreditCardValidator()
               if let type = v.type(from: txtNumber.text!){
                   if(type.name == "Amex"){
                       if (txtCVV.text!.count < 4) {
                           Alert.alert(message: "", title: "Invalid CVV")
                       }
                       else{
                           payAmount()
                       }
                   }
                   else{
                      payAmount()
                   }
               }
       
        
    }
    func payAmount(){
        expMonth = StripCheck.getValidExpiry(text: txtExpiry.text!).0
               expYear = StripCheck.getValidExpiry(text: txtExpiry.text!).1
               
               
               let cardParams = STPCardParams()
               cardParams.number = txtNumber.text!
               cardParams.expMonth = UInt(expMonth) ?? 0
               cardParams.expYear = UInt(expYear) ?? 0
               cardParams.cvc = txtCVV.text!
               cardParams.name = txtName.text!
               
               
               if !StripCheck.isCardDetailValid(cardNumber: txtNumber.text!.replacingOccurrences(of: " ", with: ""), month: UInt(expMonth) ?? 0, year: UInt(expYear) ?? 0, cvv: txtCVV.text!){
                   Alert.alert(message: "", title: "Card Detail is invalid")
                   
                   return
               }
               
               
        STPAPIClient.shared.createToken(withCard: cardParams) { (token, error) in
                   print(cardParams)
                   if error != nil {
                       print("intregation failed")
                       Alert.alert(message: "", title: "Card Detail is invalid")
                   }
                       
                   else if let token = token {
                      // print(token)
                       print(token.stripeID)
                       self.StrpiToken = token.stripeID
                       DispatchQueue.main.async {
                           
                           if self.FromViewController == "ApplicationAccepted" {
                               self.paymentWithCardForAcceptOffer()
                           }
                           else{
                            self.tokenValue = token.stripeID
                            self.paymentAlert()
                           
                           }
                       }
                   }
               }
    }
    
    func paymentAlert()
    {
        var dedectionAmount = Float(amount) ?? 0.0
        if(selectedPromoJson != nil)
        {
            let type = selectedPromoJson["TypeDiscount"].stringValue
            if(type == "in percent")
            {
                dedectionAmount = dedectionAmount - (dedectionAmount * (selectedPromoJson["Amount"].floatValue/100))
            }
            else
            {
                dedectionAmount = dedectionAmount - selectedPromoJson["Amount"].floatValue
            }
        }
        let dedectionAmountValue = Double(dedectionAmount)
        let totalAmount = (dedectionAmountValue.rounded(toPlaces: 2))
        let totalAmountValue = String(totalAmount)
        let seprateAmount = totalAmountValue.components(separatedBy: ".")
        if seprateAmount[1].count == 1{
            strAmount = totalAmountValue + "0"
        }
        else{
            strAmount = totalAmountValue
        }
        let message = """
        Do you want to pay with card ending \(txtNumber.text!.suffix(4))?
        Amount due = $\(strAmount)
        """
        let refreshAlert = UIAlertController(title: "Alert" , message: message, preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "NO", style: .destructive, handler: { (action: UIAlertAction!) in
            
        }))
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            
            DispatchQueue.main.async {
                self.makePayment(token: self.tokenValue)
            }
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    
    
    func makePayment(token:String){
        print(amount)
        print(self.PaymentType)
        let apiController : APIController = APIController()
//        let testValue = "live"
//        let testValue = "test"
        apiController.postRequest(methodName: "CreatePayment?JobId=\(jobId)&UserId=\(self.appDelegate.user_ID)&ToUserId=\(ToUserId)&refbalance=\(userModel.Balance)&CustomerId=\("")&TotalAmount=\(amount)&PaymentToken=\(token)&PaymentType=\(PaymentType)&PromoCode=\(self.promoCode)&TokenUsed=\(AppTokenUsed.tokenUsed)") { (responce) in
            if responce["message"].stringValue == "success" {
                self.userModel.Balance = responce["data"]["RefBalance"].intValue
                DispatchQueue.main.async {
                    if self.PaymentType == "Dispute"{
                        if self.userModel.DisputeImage.size.width <= 5 {
                            self.MakeDisputeApi1()
                        }
                        else{
                            self.MakeDisputeApi()
                        }
                    }
                    else if self.PaymentType == "Tip"{
                        self.TipAPI(tip: self.tipFinal, totalAmount: self.amountStrFinal)
                    }
                    else{
                        self.PaymentSucess()
                    }
                }
            }
        }
    }
    
    //CreatePayment(JobId, UserId, ToUserId, refbalance, CustomerId, TotalAmount, PaymentToken, PaymentType);

    func TipAPI(tip:Double,totalAmount:String){
//        let card : JSON = self.data[cardIndex]
        
        let apiController : APIController = APIController()
        
        let emptyStringForApilink = ""
        apiController.postRequest(methodName: "Tip?Id=\(self.tipIdFinal)&UserId=\(self.appDelegate.user_ID)&JobId=\(self.feedJsonFinal)&TippingAmount=\(tip)&TotalAmount=\(totalAmount)&SeekerId=\(self.feedJsonSeekerID)&SeekerRate=\(self.ratingstrFinal)&paymentId=\(self.paymentIdFinal)&applink=\(emptyStringForApilink)") { (responce) in
            if responce["message"].stringValue == "success"{
                self.userModel.Balance = responce["data"]["RefBalance"].intValue
                DispatchQueue.main.async {
                    if self.PaymentType == "Dispute"{
                        
                        if self.userModel.DisputeImage.size.width <= 5 {
                            self.MakeDisputeApi1()
                        }
                        else{
                            self.MakeDisputeApi()
                        }
                    }else{
                        self.PaymentSucess()
                    }
                }
            }
        }
    }
    func PaymentSucess(){
        let refreshAlert = UIAlertController(title: "Payment successfully done", message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            
            DispatchQueue.main.async {
                if(self.navigationController!.containsViewController(ofKind: MyListHomeViewController.self))
                {
                    self.navigationController!.popToViewController(ofClass: MyListHomeViewController.self)
                }
                else if (self.navigationController!.containsViewController(ofKind: MyProfileViewController.self))
                {
                    self.navigationController!.popToViewController(ofClass: MyProfileViewController.self)
                }
                else
                {
                    self.navigationController!.popToViewController(ofClass: HomeViewController.self)

                }
            }
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
       
    
    func paymentWithCardForAcceptOffer(){
        
        
        var refBalance = Double()
        var AmountWithAdminCharges = Double()
        if(self.amount == "")
        {
            AmountWithAdminCharges = userModel.ListerJobData["AmountWithAdminCharges"].doubleValue
        }
        else
        {
            AmountWithAdminCharges = Double(self.amount)!
        }
        refBalance = userModel.Balance.doubleValue
        
        var dedectedAmount = Float(AmountWithAdminCharges)
        if(selectedPromoJson != nil)
        {
            let type = selectedPromoJson["TypeDiscount"].stringValue
            
            if(type == "in percent")
            {
                dedectedAmount = dedectedAmount - (dedectedAmount * (selectedPromoJson["Amount"].floatValue/100))
            }
            else
            {
                dedectedAmount = dedectedAmount - selectedPromoJson["Amount"].floatValue
            }
        }
        
        let Total = dedectedAmount - Float(refBalance)
        
        var Message = ""
        
        if refBalance == 0 {
            let doubleValueAmount = Double(dedectedAmount)
            let totalAmount = (doubleValueAmount.rounded(toPlaces: 2))
            let totalAmountValue = String(totalAmount)
            let seprateAmount = totalAmountValue.components(separatedBy: ".")
            if seprateAmount[1].count == 1{
                strAmount = totalAmountValue + "0"
            }
            else{
                strAmount = totalAmountValue
            }
            
//            Amount to be paid : $\(dedectedAmount.withCommas())
            
            Message = """
            Do you want to pay with card ending \(txtNumber.text!.suffix(4))?
            Amount to be paid : $\(strAmount)
            """
            
        }
            
        else {
            let doubleValueAmount = Double(dedectedAmount)
            let totalAmount = (doubleValueAmount.rounded(toPlaces: 2))
            let totalAmountValue = String(totalAmount)
            let seprateAmount = totalAmountValue.components(separatedBy: ".")
            if seprateAmount[1].count == 1{
                strAmount = totalAmountValue + "0"
            }
            else{
                strAmount = totalAmountValue
            }
            
            
            let doubleValueAmount1 = Double(Total)
            let totalAmount1 = (doubleValueAmount1.rounded(toPlaces: 2))
            let totalAmountValue1 = String(totalAmount1)
            let seprateAmount1 = totalAmountValue.components(separatedBy: ".")
            if seprateAmount1[1].count == 1{
                strAmount1 = totalAmountValue1 + "0"
            }
            else{
                strAmount1 = totalAmountValue1
            }
            
            
            
            
            Message = """
            Do you want to pay with card ending \(txtNumber.text!.suffix(4))?
            
            Total Payment = \(strAmount)
            
            Amount debited from Referral Balance = \(refBalance)
            
            Amount to be paid from Card = \(strAmount1)
            """
            
        }
        
        
        
        let alert = UIAlertController(title: "\n\n\(Message)\n", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.MakePaymentForAccept(Totalamount: dedectedAmount)
        }))
        
        
        self.present(alert, animated: true)
        
    }

    func MakePaymentForAccept(Totalamount:Float){
        
        let apiController : APIController = APIController()
//        let testValue = "live"
//        let testValue = "test"
        apiController.postRequest(methodName: "CreatePayment?JobId=\(jobId)&UserId=\(self.appDelegate.user_ID)&ToUserId=\(ToUserId)&refbalance=\(userModel.Balance)&CustomerId=\("")&TotalAmount=\(Totalamount)&PaymentToken=\(self.StrpiToken)&PaymentType=\(self.PaymentType)&PromoCode=\(self.promoCode)&TokenUsed=\(AppTokenUsed.tokenUsed)") { (responce) in
            if responce["message"].stringValue == "success" {
                self.userModel.Balance = responce["data"]["RefBalance"].intValue
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate.doneAction(paymentMode: "sucess", paymentType: "")
                }
            }
        }
    }
    
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

       }
    
    @IBAction func btnASaveCard(_ sender: UIButton) {
           if (sender.isSelected == true)
           {
               sender.setBackgroundImage(UIImage(named: "Filter_unchecked"), for: .normal)

               sender.isSelected = false;
           }
           else
           {
               sender.setBackgroundImage(UIImage(named: "Filter_checked"), for: .normal)

               sender.isSelected = true;
           }

       }
    
    func MakeDisputeApi(){
        
        let params : [String:Any] = ["Id":"0",
                                     "UserId":"\(appDelegate.user_ID)",
            "JobId":"\(jobId)",
            "DisputeReason":"\(userModel.DisputeReason)",
            "PostAssociate":"\(userModel.DisputePostAssociate)",
            "Description":"\(userModel.DisputeDescription)"]
        
        print("params",params)
        print(userModel.DisputeImage)
        let apiController : APIController = APIController()
        apiController.postMultipart(params: params, image: userModel.DisputeImage, methodName: "Dispute") { (responce) in
            if responce["message"].stringValue == "success" {
                DispatchQueue.main.async {
                    self.navigationController?.popToViewController(ofClass: MyProfileViewController.self)
                }
                
            }
        }
    }
    
    func MakeDisputeApi1(){
        let imageValue = ""
           let params : [String:Any] = ["Id":"0",
                                        "UserId":"\(appDelegate.user_ID)",
               "JobId":"\(jobId)",
               "DisputeReason":"\(userModel.DisputeReason)",
               "PostAssociate":"\(userModel.DisputePostAssociate)",
            "image": "\(imageValue)",
               "Description":"\(userModel.DisputeDescription)"]
           
           print("params",params)
           print(userModel.DisputeImage)
           let apiController : APIController = APIController()
        apiController.postMultipart1(methodName: "Dispute", params:params) { (responce) in
               if responce["message"].stringValue == "success" {
                   DispatchQueue.main.async {
                       self.navigationController?.popToViewController(ofClass: MyProfileViewController.self)
                   }
                   
               }
           }
       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard ((textField.text as NSString?)?.replacingCharacters(in: range, with: string)) != nil else { return true }
        
        if textField == txtNumber {
            
            var originalText = textField.text
            
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                }else{
                    let rangeIndex = range.location
                    
                    if rangeIndex % 5 == 0 {
                        originalText?.append(" ")
                        txtNumber.text = originalText
                    }
                }
            }
            let v = CreditCardValidator()
            if let type = v.type(from: txtNumber.text!){
                 // Visa, Mastercard, Amex etc.
                if(type.name == "Amex")
                {
                    txtCVV.maxLength = 4
                }
                else
                {
                    txtCVV.maxLength = 3
                }
            } else {
                // I Can't detect type of credit card
            }
            return true
            
            
        }
        else if textField == txtExpiry {
            
            var originalText = textField.text
            
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                }else{
                    if range.location == 2 {
                        originalText?.append("/")
                        
                        txtExpiry.text = originalText
                    }
                }
            }
            return true
            
            
        }
        else {
            return true
        }
    }
}



protocol PaymentNewCardForOfferAccept {
    func doneAction(paymentMode:String,paymentType:String)
}

//
//  SelectPaymentViewController.swift
//  Azzida
//
//  Created by iVishnu on 25/08/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class SelectPaymentViewController: UIViewController {
    @IBOutlet weak var collectionVw : UICollectionView!
    @IBOutlet weak var btnView : UIView!
    @IBOutlet weak var btnHavePromoCode: UIButton!
    @IBOutlet weak var lblPromoApplied: UILabel!
    
    @IBOutlet weak var heightPaymentView: NSLayoutConstraint!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var data : [JSON] = []
    var cardIndex = 0
    var jobId = 0
    var amount = ""
    var delegate : SucessPaymentDelegate! = nil
    var PaymentType = ""
    let userModel : UserModel = UserModel.userModel
    var ToUserId = 0
    var FromViewController = ""
    var acceptOfferPaymentDelegate : AcceptOfferPaymentDelegate! = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var amountStrFinal = ""
    var tipFinal = Double()
    var tipIdFinal = "0"
    var feedJsonFinal = 0
    var feedJsonSeekerID = 0
    var ratingstrFinal = ""
    var paymentIdFinal = ""
    var emptyStringForApilink = ""
    var FeedJson = JSON()
    var promoCode = ""
    var promoList:[JSON] = []
    var selectedPromoJson:JSON = JSON()
    var showPromoCode:Bool = true
    var promoCodeHide : String!
    var paymentValue : String!
    var FromViewControllerTip = ""
    var strAmount = ""
    var strAmount1 = ""
    var paymentMsg = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionVw.register(UINib(nibName: "PaymentCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PaymentCardCollectionViewCell")
        GetCustomerCards()
        getPromoCodeList()
        //print("amount",amount)
        
        self.btnHavePromoCode.isHidden = !showPromoCode
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if promoCodeHide == "true"{
            heightPaymentView.constant = 380
            btnHavePromoCode.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        promoCodeHide = ""
        paymentValue = ""
    }
    func GetCustomerCards(){
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "GetCustomerCards?UserId=\(appDel.user_ID)") { (responce) in
            if responce["message"].stringValue == "success" {
                self.data = responce["data"].arrayValue
                DispatchQueue.main.async {
                    self.collectionVw.reloadData()
                }
            }
        }
    }
    
    func getPromoCodeList()
    {
        APIController().getPromoCodeList() { (response) in
            print(response)
            self.promoList = response["data"].arrayValue
        }
    }
    
    
    @objc func closeTab(sender:UITapGestureRecognizer) {
        print("tap working")
        ///  self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnPayWithNewCard(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if FromViewController == "ApplicationAccepted"{
            self.acceptOfferPaymentDelegate.selectPayment(paymentMode: "NewCard", PaymentMethoda: "", PaymentType: self.PaymentType, selectedPromoJson: selectedPromoJson ?? "", selectedCode: promoCode)
        }
        else if FromViewControllerTip == "Tip"{
            self.delegate.backPopup(PaymentType: "Tip", PaymentMethod: PaymentType, selectedPromoJson: self.selectedPromoJson, selectedCode: self.promoCode)
        }else{
            self.delegate.backPopup(PaymentType: "NewCard", PaymentMethod: PaymentType, selectedPromoJson: self.selectedPromoJson, selectedCode: self.promoCode)
        }
    }
    
    @IBAction func btnPayWithExitingCard(_ sender: UIButton) {
        
        
        //        let vc = Mainstoryboard.instantiateViewController(withIdentifier: "EditPaymentViewController") as! EditPaymentViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
        // self.dismiss(animated: true, completion: nil)
        // self.delegate.dismisViewController()
    }
    
    @IBAction func havePromoCodeAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Promo Code", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Promo Code"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print(firstTextField.text!)
            var validPromoCode = false
            for item in self.promoList
            {
                if(item["Code"].stringValue == firstTextField.text!)
                {
                    self.selectedPromoJson = item
                    self.lblPromoApplied.text = "Promo code Applied \(item["Code"].stringValue)"
                    validPromoCode = true
                }
            }
            if(!validPromoCode)
            {
                Utilities.alert("Invalid code")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func TipAPI(tip:Double,totalAmount:String){
        let card : JSON = self.data[cardIndex]
        
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
        Do you want to pay with card ending \(data[cardIndex]["CardNumber"].stringValue)?
        
        Amount due = $\(strAmount)
        """
        let refreshAlert = UIAlertController(title: "Alert" , message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "NO", style: .destructive, handler: { (action: UIAlertAction!) in
            
        }))
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            
            DispatchQueue.main.async {
                self.makePayment()
            }
        }))
        
       
        
        present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    func makePayment(){
        let card : JSON = self.data[cardIndex]
        print(amount)
        if(selectedPromoJson != nil)
        {
            promoCode = selectedPromoJson["Code"].stringValue
        }
        let apiController : APIController = APIController()
//        let testValue = "live"
//        let testValue = "test"
        apiController.postRequest(methodName: "CreatePayment?JobId=\(jobId)&UserId=\(self.appDel.user_ID)&ToUserId=\(ToUserId)&refbalance=\(userModel.Balance)&CustomerId=\(card["CustomerId"].stringValue)&TotalAmount=\(amount)&PaymentToken=\("")&PaymentType=\(PaymentType)&PromoCode=\(self.promoCode)&TokenUsed=\(AppTokenUsed.tokenUsed)") { (responce) in
            if responce["message"].stringValue == "success" {
                self.userModel.Balance = responce["data"]["RefBalance"].intValue
                if self.paymentValue == "true"{
                    if self.userModel.DisputeImage.size.width <= 5 {
                        self.MakeDisputeApi1()
                    }
                    else{
                        self.MakeDisputeApi()
                    }
                    
                }else{
                    self.TipAPI(tip: self.tipFinal, totalAmount: self.amountStrFinal)
                }
            }
        }
    }
    
    //CreatePayment(JobId, UserId, ToUserId, refbalance, CustomerId, TotalAmount, PaymentToken, PaymentType);
    
    func PaymentSucess(){
        let refreshAlert = UIAlertController(title: "Payment successfully done", message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                
                
                self.delegate.backPopup(PaymentType: "", PaymentMethod: self.PaymentType, selectedPromoJson: self.selectedPromoJson, selectedCode: self.promoCode)
                
                
                
            }
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if self.btnView.frame.contains(location) {
            print("Tapped outside the view")
        } else {
            print("Tapped inside the view")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func MakeDisputeApi(){
        
        let params : [String:Any] = ["Id":"0",
                                     "UserId":"\(appDel.user_ID)",
            "JobId":"0",
            "DisputeReason":"\(userModel.DisputeReason)",
            "PostAssociate":"\(userModel.DisputePostAssociate)",
            "Description":"\(userModel.DisputeDescription)"]
        
        print("params",params)
        
        let apiController : APIController = APIController()
        apiController.postMultipart(params: params, image: userModel.DisputeImage, methodName: "Dispute") { (responce) in
            if responce["message"].stringValue == "success" {
                DispatchQueue.main.async {
                    self.PaymentSucess()
self.navigationController?.popToViewController(ofClass: MyProfileViewController.self)
//                    self.dismiss(animated: true, completion: nil)
//                    
//                    self.delegate.backPopup(PaymentType: "", PaymentMethod: self.PaymentType, selectedPromoJson: self.selectedPromoJson, selectedCode: self.promoCode)
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
                    self.PaymentSucess()
                    self.navigationController?.popToViewController(ofClass: MyProfileViewController.self)
                }
                
            }
        }
    }
    func paymentWithCardForAcceptOffer(){
        
        var refBalance = Double()
        var amountWithAdminCharges = Double()
        amountWithAdminCharges = Double(self.amount) ?? 0.0
        refBalance = userModel.Balance.doubleValue
        var dedectedAmount = Float(amountWithAdminCharges)
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
        
        let total = amountWithAdminCharges - refBalance
        var dedectedAmountValue = Double(dedectedAmount)
        
        var message = ""
        if refBalance == 0 {
            if paymentMsg == "true"{
                let totalAmount = (dedectedAmountValue.rounded(toPlaces: 2))
                let totalAmountValue = String(totalAmount)
                let seprateAmount = totalAmountValue.components(separatedBy: ".")
                if seprateAmount[1].count == 1{
                    strAmount = totalAmountValue + "0"
                }
                else{
                    strAmount = totalAmountValue
                }
                message = """
            Do you want to pay with card ending \(data[cardIndex]["CardNumber"].stringValue)?
            Amount to be paid = $\(strAmount)
            
            
            **Payment will be held and not released to Job Performer until job completion and confirmation
            """
            }
            else{
            let totalAmount = (dedectedAmountValue.rounded(toPlaces: 2))
            let totalAmountValue = String(totalAmount)
            let seprateAmount = totalAmountValue.components(separatedBy: ".")
            if seprateAmount[1].count == 1{
                strAmount = totalAmountValue + "0"
            }
            else{
                strAmount = totalAmountValue
            }
            message = """
            Do you want to pay with card ending \(data[cardIndex]["CardNumber"].stringValue)?
            Amount to be paid = $\(strAmount)
            """
            }
        }
            
        else {
            let totalAmount = (total.rounded(toPlaces: 2))
            let totalAmountValue = String(totalAmount)
            let seprateAmount = totalAmountValue.components(separatedBy: ".")
            if seprateAmount[1].count == 1{
                strAmount = totalAmountValue + "0"
            }
            else{
                strAmount = totalAmountValue
            }
            let doubleValueAmount = Double(dedectedAmount)
            let totalAmount1 = (doubleValueAmount.rounded(toPlaces: 2))
            let totalAmountValue1 = String(totalAmount1)
            let seprateAmount1 = totalAmountValue.components(separatedBy: ".")
            if seprateAmount1[1].count == 1{
                strAmount1 = totalAmountValue1 + "0"
            }
            else{
                strAmount1 = totalAmountValue1
            }
      
            message = """
            Do you want to pay with card ending \(data[cardIndex]["CardNumber"].stringValue)?
            
            Total Payment = \(strAmount1)
            
            Amount debited from Referral Balance = \(refBalance)
            
            Amount to be paid from Card = \(strAmount)
            """
        }
        
        let alert = UIAlertController(title: "\n\n\(message)\n", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.MakePaymentForAccept(Totalamount: amountWithAdminCharges)
        }))
       
        self.present(alert, animated: true)
        
    }
    
    func MakePaymentForAccept(Totalamount:Double){
        let card : JSON = self.data[cardIndex]
        
        let apiController : APIController = APIController()
//        let testValue = "test"
        apiController.postRequest(methodName: "CreatePayment?JobId=\(jobId)&UserId=\(self.appDel.user_ID)&ToUserId=\(ToUserId)&refbalance=\(userModel.Balance)&CustomerId=\(card["CustomerId"].stringValue)&TotalAmount=\(Totalamount)&PaymentToken=\("")&PaymentType=Payment&PromoCode=\(self.promoCode)&TokenUsed=\(AppTokenUsed.tokenUsed)") { (responce) in
            if responce["message"].stringValue == "success" {
                self.userModel.Balance = responce["data"]["RefBalance"].intValue
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    self.acceptOfferPaymentDelegate.selectPayment(paymentMode: "sucess", PaymentMethoda: "", PaymentType: "", selectedPromoJson: self.selectedPromoJson ?? nil, selectedCode: self.promoCode)
                    //self.navigationController?.popToViewController(ofClass: self.userModel.UserMainActivity)
                }
            }
        }
    }
}




extension SelectPaymentViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentCardCollectionViewCell", for: indexPath) as! PaymentCardCollectionViewCell
        cell.lblName.text = "Ending with \(data[indexPath.item]["CardNumber"].stringValue)"
        
        if data[indexPath.item]["CardType"].stringValue == "Discover" {
            cell.cardImage.image = UIImage(named: "ic_discover")
        }
        else if data[indexPath.item]["CardType"].stringValue == "Visa"{
            cell.cardImage.image = UIImage(named: "ic_visa")
        }
        else if data[indexPath.item]["CardType"].stringValue == "MasterCard"{
            cell.cardImage.image = UIImage(named: "ic_mastercard")
        }
        else if data[indexPath.item]["CardType"].stringValue == "American Express"{
            cell.cardImage.image = UIImage(named: "ic_amex")
        }
        else{
            cell.cardImage.image = #imageLiteral(resourceName: "noimage")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 123)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cardIndex = indexPath.item
        if FromViewController == "ApplicationAccepted"{
            self.paymentWithCardForAcceptOffer()
        }
        else{
            self.paymentAlert()
        }
    }
}


protocol SucessPaymentDelegate {
    func backPopup(PaymentType:String,PaymentMethod:String, selectedPromoJson:JSON, selectedCode:String)
}

protocol AcceptOfferPaymentDelegate {
    func selectPayment(paymentMode:String,PaymentMethoda:String,PaymentType:String, selectedPromoJson:JSON?, selectedCode:String?)
}

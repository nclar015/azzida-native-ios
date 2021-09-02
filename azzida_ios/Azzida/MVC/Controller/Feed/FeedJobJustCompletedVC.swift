//
//  FeedJobJustCompletedVC.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 10/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class FeedJobJustCompletedVC: UIViewController {
    
    @IBOutlet weak var img_view: UIImageView!
    @IBOutlet weak var btnEnterAmount: UIButton!
    @IBOutlet weak var btn_5_percent: UIButton!
    @IBOutlet weak var btn_10_percent: UIButton!
    @IBOutlet weak var btn_20_percent: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPricewon: UILabel!
    @IBOutlet weak var btnYouWon: UIButton!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    let constant : CommonStrings = CommonStrings.commonStrings
    var FeedJson = JSON()
    var Ratingstr = ""
    var PaymentType = "Payment"
    var tipAmount = ""
    var tip = Double()
    var tipId = "0"
    var paymentId = ""
    var amountTotalStr = ""
    var isCustomAmount = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.delegate = self
        ratingView.type = .halfRatings
        self.tipId = FeedJson["TipId"].stringValue
        self.paymentId = FeedJson["PymntId"].stringValue
        getSekerName()
        
        img_view.downloadImage(url: FeedJson["Seekerimage"].stringValue)
        
        btnYouWon.setTitle("Your job was $\(FeedJson["Amount"].intValue)", for: .normal)
        
        //  changeButton(blueBtn: btn_5_percent, whiteBtn_1: btn_10_percent, whiteBtn_2: btn_20_percent)
        //  lblPricewon.text = "Your job was $\(calculatePercentage(value: FeedJson["Amount"].doubleValue, percentageVal: 0))"
        resetPrice()
        self.txtAmount.isUserInteractionEnabled = false
        
        btn_5_percent.setTitleColor(.black, for: .normal)
        btn_5_percent.backgroundColor = .white
        
        btn_10_percent.setTitleColor(.black, for: .normal)
        btn_10_percent.backgroundColor = .white
        
        btn_20_percent.backgroundColor = .white
        btn_20_percent.setTitleColor(.black, for: .normal)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //  navigationController?.navigationBar.barTintColor = constant.theamColor
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        btnEnterAmount.underline()
    }
    
    func getSekerName(){
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "UserId":FeedJson["SeekerId"].intValue
        ]
        apiController.getRequest(methodName: "GetProfile", param: param, isHUD: false) { (responce) in
            if responce["message"].stringValue == "success" {
                self.lblName.text = "How would you rate \(responce["data"]["FirstName"].stringValue) \(responce["data"]["LastName"].stringValue)?"
            }
        }
        
        
    }
    
    func calculatePercentage(value:Double,percentageVal:Double)->String{
        var val = value * percentageVal
        val = val / 100.0
        
        //tipAmount
        tipAmount = String(format: "%.2f", val)
        

        
        val = value + val
//        var vals : String = String(val.rounded())
//        vals = vals.replacingOccurrences(of: ".0", with: "")
        return String(format: "%.2f", val)
    }
    
    func resetPrice(){
        lblPricewon.text = "Your job was $\(FeedJson["Amount"].stringValue)"
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEnterAmount(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter a Custom Amount", message: "", preferredStyle: UIAlertController.Style.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.txtAmount.text = firstTextField.text ?? ""
            self.isCustomAmount = true
            self.tipAmount = self.txtAmount.text!
            self.lblPricewon.text = "Your job was $\(self.FeedJson["Amount"].doubleValue+JSON(self.txtAmount.text ?? 0.0).doubleValue)"
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter a Custom Amount"
            textField.keyboardType = .decimalPad
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btn_5_percent(_ sender: UIButton) {
        if sender.backgroundColor == constant.theamColor{
            resetPrice()
            resetButtons(button: sender)
            tipAmount = ""
            
        }
        else{
            changeButton(blueBtn: btn_5_percent, whiteBtn_1: btn_10_percent, whiteBtn_2: btn_20_percent)
            lblPricewon.text = "Your job was $\(calculatePercentage(value: FeedJson["Amount"].doubleValue, percentageVal: 5))"
        }
    }
    
    @IBAction func btn_10_percent(_ sender: UIButton) {
        if sender.backgroundColor == constant.theamColor{
            resetPrice()
            resetButtons(button: sender)
            tipAmount = ""
        }else{
            changeButton(blueBtn: btn_10_percent, whiteBtn_1: btn_5_percent, whiteBtn_2: btn_20_percent)
            lblPricewon.text = "Your job was $\(calculatePercentage(value: FeedJson["Amount"].doubleValue, percentageVal: 10))"
        }
    }
    
    @IBAction func btn_20_percent(_ sender: UIButton) {
        if sender.backgroundColor == constant.theamColor{
            resetPrice()
            resetButtons(button: sender)
            tipAmount = ""
        }else{
            changeButton(blueBtn: btn_20_percent, whiteBtn_1: btn_5_percent, whiteBtn_2: btn_10_percent)
            lblPricewon.text = "Your job was $\(calculatePercentage(value: FeedJson["Amount"].doubleValue, percentageVal: 20))"
        }
    }
    
    func changeButton(blueBtn:UIButton,whiteBtn_1:UIButton,whiteBtn_2:UIButton){
        whiteBtn_1.setTitleColor(.black, for: .normal)
        whiteBtn_1.backgroundColor = .white
        
        whiteBtn_2.setTitleColor(.black, for: .normal)
        whiteBtn_2.backgroundColor = .white
        
        blueBtn.backgroundColor = constant.theamColor
        blueBtn.setTitleColor(.white, for: .normal)
        
        self.isCustomAmount = false
        self.txtAmount.text = ""
        
    }
    
    func resetButtons(button:UIButton){
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
    }
    
    @IBAction func btnWon(_ sender: UIButton) {
        
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        if Ratingstr == "" || Ratingstr == "0.0" {
            Alert.alert(message: "", title: "Give Rating.")
            return
        }
        var amountStr = ""
        if self.isCustomAmount{
            amountStr = txtAmount.text ?? ""
        }
        else{
            amountStr = lblPricewon.text!.replacingOccurrences(of: "Your job was $", with: "")
        }
        print("amountStr",amountStr)
        //self.showPaymentPopup(amount: amountStr)
        tipApi(amountTotal: amountStr)
    }
    
    func tipApi(amountTotal:String){
        print(tipAmount)
        if tipAmount == "" {
            self.amountTotalStr = amountTotal
            print(amountTotal)
            tip = 0.0
            self.TipAPI(tip: tip, totalAmount: amountTotal)
        }else{
            
             tip = (tipAmount as NSString).doubleValue
             //self.pushData()
             self.amountTotalStr = amountTotal
            print(tip)
             self.showPaymentPopup(amount: "\(tip)")
        }
        print("tip",tip)
        print("amountTotal",amountTotal)
        print(paymentId)
    }
    
    
    func TipAPI(tip:Double,totalAmount:String){
        let emptyStringForApilink = ""
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "Tip?Id=\(tipId)&UserId=\(appDelegate.user_ID)&JobId=\(FeedJson["JobId"].intValue)&TippingAmount=\(tip)&TotalAmount=\(totalAmount)&SeekerId=\(FeedJson["SeekerId"].intValue)&SeekerRate=\(Ratingstr)&paymentId=\(paymentId)&applink=\(emptyStringForApilink)") { (responce) in
            if responce["message"].stringValue == "success"{
                let refreshAlert = UIAlertController(title: "Payment successfully done", message: "", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                    
                    DispatchQueue.main.async {
                        self.navigationController?.navigationBar.isHidden = false
                        if(self.navigationController!.containesViewController(ofClass: MyListHomeViewController.self))
                        {
                            self.navigationController?.popToViewController(ofClass: MyProfileViewController.self)
                        }
                        else if(self.navigationController!.containesViewController(ofClass: MyProfileViewController.self))
                        {
                            self.navigationController?.popToViewController(ofClass: MyProfileViewController.self)
                        }
                        else if(self.navigationController!.containesViewController(ofClass: FeedJobJustCompletedVC.self))
                        {
                            self.navigationController?.popToViewController(ofClass: HomeViewController.self)
                        }
                        else
                        {
                            self.navigationController?.popToViewController(ofClass: MyProfileViewController.self)                        }
                    }
                }))
                self.present(refreshAlert, animated: true, completion: nil)
                
            }
        }
    }
    
    func showPaymentPopup(amount:String){
        let vc = SecondStoryboard.instantiateViewController(withIdentifier: "SelectPaymentViewController") as! SelectPaymentViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.PaymentType = PaymentType
        vc.amount = amount
        vc.jobId = FeedJson["JobId"].intValue
        vc.delegate = self
        vc.ToUserId = FeedJson["SeekerId"].intValue
        vc.FromViewController = "FeedJobJustCompletedVC"
        
        vc.tipIdFinal = tipId
        vc.feedJsonFinal = FeedJson["JobId"].intValue
        vc.feedJsonSeekerID = FeedJson["SeekerId"].intValue
        vc.ratingstrFinal = Ratingstr
        vc.paymentIdFinal = paymentId
        vc.tipFinal = tip
        vc.amountStrFinal = amountTotalStr
        vc.showPromoCode = false
        vc.FromViewControllerTip = "Tip"
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension FeedJobJustCompletedVC: FloatRatingViewDelegate {
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        //  print("1")
        // print(String(format: "%.2f", self.RateView.rating))
        // liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        // print("2")
        print(String(format: "%.1f", self.ratingView.rating))
        Ratingstr = String(format: "%.1f", self.ratingView.rating)
        //updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating) 52 114  193
    }
    
}

extension FeedJobJustCompletedVC: SucessPaymentDelegate{
    
    func backPopup(PaymentType: String, PaymentMethod: String, selectedPromoJson: JSON, selectedCode: String) {
        
        if PaymentType == "NewCard" {
            let vc = SecondStoryboard.instantiateViewController(withIdentifier: "PayWithNewCardViewController") as! PayWithNewCardViewController
            vc.PaymentType = self.PaymentType
            vc.amount = "\(tip)"
            vc.jobId = FeedJson["JobId"].intValue
            vc.ToUserId = FeedJson["SeekerId"].intValue
            vc.PaymentType = PaymentType
//          
//            vc.jobId = FeedJson["JobId"].intValue
//            vc.ToUserId = FeedJson["SeekerId"].intValue
//            vc.FromViewController = "FeedJobJustCompletedVC"
//            
//            vc.tipIdFinal = tipId
//            vc.feedJsonFinal = FeedJson["JobId"].intValue
//            vc.feedJsonSeekerID = FeedJson["SeekerId"].intValue
//            vc.ratingstrFinal = Ratingstr
//            vc.paymentIdFinal = paymentId
//            vc.tipFinal = tip
//            vc.amountStrFinal = amountTotalStr
              self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if PaymentType == "Tip" {
            let vc = SecondStoryboard.instantiateViewController(withIdentifier: "PayWithNewCardViewController") as! PayWithNewCardViewController
            print(tip)
            vc.PaymentType = self.PaymentType
            vc.amount = "\(tip)"
            vc.jobId = FeedJson["JobId"].intValue
            vc.ToUserId = FeedJson["SeekerId"].intValue
            vc.PaymentType = PaymentType
            
            vc.jobId = FeedJson["JobId"].intValue
            vc.ToUserId = FeedJson["SeekerId"].intValue
            vc.FromViewController = "FeedJobJustCompletedVC"
            
            vc.tipIdFinal = tipId
            vc.feedJsonFinal = FeedJson["JobId"].intValue
            vc.feedJsonSeekerID = FeedJson["SeekerId"].intValue
            vc.ratingstrFinal = Ratingstr
            vc.paymentIdFinal = paymentId
            vc.tipFinal = tip
            vc.amountStrFinal = amountTotalStr
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            if PaymentMethod == "Dispute"{
                self.navigationController?.popToViewController(ofClass: MyProfileViewController.self)
            }
            else{
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.popToViewController(ofClass: HomeViewController.self)
            }
        }
    }
    
    
}



extension String {
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
        }.joined().dropFirst())
    }
    
    
}

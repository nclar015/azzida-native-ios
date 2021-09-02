//
//  OptionViewController.swift
//  Azzida
//
//  Created by iVishnu on 03/09/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController {
    
    @IBOutlet weak var btnCheckrStatus: UIButton!
    @IBOutlet weak var lblCheckr4: UILabel!
    @IBOutlet weak var lblCheckr3: UILabel!
    @IBOutlet weak var lblCheckr1: UILabel!
    @IBOutlet weak var lblCheckr2: UILabel!
    @IBOutlet weak var viewCheckr1: UIView!
    @IBOutlet weak var viewCheckr4: UIView!
    
    @IBOutlet weak var viewCheckr3: UIView!
    @IBOutlet weak var viewCheckr2: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var viewBlackVw: UIView!
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var btnVerified: RoundButton!
    var optionArr = ["Checkr Opiton "]
    var amount:Double = Double()
    var refBalance = Double()
    var promoCode = ""
    var selectedPromoJson:JSON!
    let userModel : UserModel = UserModel.userModel
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var ssnStatus : String!
    var sexOffenderStatus : String!
    var globalStatus : String!
    var nationlStatus : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.isHidden = true
        refBalance = UserModel.userModel.Balance.doubleValue
        
    }
    override func viewWillAppear(_ animated: Bool) {
        APIController().getJobFee { (response) in
            self.amount = response["data"]["BackgroundCheck"].doubleValue
            self.btnVerified.setTitle("Background Check Badge Application :$\(self.amount)", for: .normal)
        }
        btnCheckrStatus.isHidden = true
        if self.userModel.azzidaVerified == true{
            btnCheckrStatus.isHidden = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    @IBAction func actionCloseBtn(_ sender: Any) {
        viewBlackVw.isHidden = true
        subView.isHidden = true
    }
    @IBAction func actionCheckr(_ sender: Any) {
        guard let url = URL(string: "https://candidate.checkr.com/view#login") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func actionCheckStatus(_ sender: UIButton) {
                 checkrReprort()
        
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOption(_ sender: UIButton) {
        if(UserModel.userModel.azzidaVerified)
        {
            ServiceManager.alert(message: "Already Verified!")
            return
        }
        //        tblView.isHidden = false
        let webViewController:OptionWebViewController = self.storyboard?.instantiateViewController(withIdentifier: "OptionWebViewController") as! OptionWebViewController
        webViewController.delegate = self
        //        self.navigationController?.pushViewController(webViewController, animated: true)
        self.present(webViewController, animated: true, completion: nil)
        
    }
    func checkrReprort(){
        let apiController : APIController = APIController()
        print(appDelegate.user_ID)
        print(self.userModel.candidateId)
        apiController.postRequest(methodName: "CheckerReport?UserId=\(appDelegate.user_ID)&CandidateId=\(userModel.candidateId)") { (responce) in
            if responce["message"].stringValue == "success"{
                self.lblCheckr1.text = responce["data"]["SsnTraceStatus"].stringValue
                self.lblCheckr2.text = responce["data"]["SexOffenderStatus"].stringValue
                self.lblCheckr3.text  = responce["data"]["GlobalStatus"].stringValue
                self.lblCheckr4.text = responce["data"]["NationalStatus"].stringValue
                //if (((self.lblCheckr1!.text) != nil) )  && ((self.lblCheckr2!.text != nil))  && ((self.lblCheckr3!.text != nil)) && (self.lblCheckr4.text) == "clear" {
                  //  self.btnCheckrStatus.isHidden = false
               // }
                self.checkrStatus()
                self.viewBlackVw.isHidden = false
                      self.subView.isHidden = false
                
            }
        }
    }
    func checkrStatus(){
        if lblCheckr1.text == "clear"{
            viewCheckr1.backgroundColor = UIColor.init(red: 92/255, green: 194/255, blue: 92/255, alpha: 1.0)        }
        else if lblCheckr1.text == "consider"{
            viewCheckr1.backgroundColor =  UIColor.init(red: 240/255, green: 173/255, blue: 78/255, alpha: 1.0)
            
        }else{
            viewCheckr1.backgroundColor = UIColor.init(red: 204/255, green: 0/255, blue: 102/255, alpha: 1.0)
            
        }
        if lblCheckr2.text == "clear"{
            viewCheckr2.backgroundColor = UIColor.init(red: 92/255, green: 194/255, blue: 92/255, alpha: 1.0)
        }
        else if lblCheckr2.text == "consider"{
            viewCheckr2.backgroundColor = UIColor.init(red: 240/255, green: 173/255, blue: 78/255, alpha: 1.0)
            
        }else{
            viewCheckr2.backgroundColor =  UIColor.init(red: 204/255, green: 0/255, blue: 102/255, alpha: 1.0)
        }
        if lblCheckr3.text == "clear"{
            viewCheckr3.backgroundColor = UIColor.init(red: 92/255, green: 194/255, blue: 92/255, alpha: 1.0)
        }
        else if lblCheckr3.text == "consider"{
            viewCheckr3.backgroundColor = UIColor.init(red: 240/255, green: 173/255, blue: 78/255, alpha: 1.0)
            
        }else{
            viewCheckr3.backgroundColor =  UIColor.init(red: 204/255, green: 0/255, blue: 102/255, alpha: 1.0)
        }
        if lblCheckr4.text == "clear"{
            viewCheckr4.backgroundColor = UIColor.init(red: 92/255, green: 194/255, blue: 92/255, alpha: 1.0)
        }
        else if lblCheckr4.text == "consider"{
            viewCheckr4.backgroundColor = UIColor.init(red: 240/255, green: 173/255, blue: 78/255, alpha: 1.0)
            
        }else{
            viewCheckr4.backgroundColor =  UIColor.init(red: 204/255, green: 0/255, blue: 102/255, alpha: 1.0)
        }
    }
    
    func paymentWithRefBalance(){
        let alert = UIAlertController(title: "Amount debited from Referral Balance = \(self.amount)\n", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.makePaymentWithRefBalance()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func showPaymentPopup(amount:String){
        let vc = SecondStoryboard.instantiateViewController(withIdentifier: "SelectPaymentViewController") as! SelectPaymentViewController
        vc.promoCodeHide = "true"
        vc.modalPresentationStyle = .overFullScreen
        vc.PaymentType = "Checker"
        vc.amount = amount
        vc.jobId = 0
        vc.acceptOfferPaymentDelegate = self
        vc.ToUserId = 0
        vc.FromViewController = "ApplicationAccepted"
        self.present(vc, animated: true, completion: nil)
    }
    
    func makePaymentWithRefBalance(){
        let apiController : APIController = APIController()
//        let testValue = "live"
//        let testValue = "test"
        apiController.postRequest(methodName: "CreatePayment?JobId=\(0)&UserId=\(AppDelegate.sharedDelegate().user_ID)&ToUserId=\(0)&refbalance=\(refBalance)&CustomerId=\("")&TotalAmount=\(self.amount)&PaymentToken=\("")&PaymentType=Payment&PromoCode=\("")&TokenUsed=\(AppTokenUsed.tokenUsed)") { (responce) in
            if responce["message"].stringValue == "success" {
                DispatchQueue.main.async {
                    let vc = Mainstoryboard.instantiateViewController(withIdentifier: "CheckrFormViewController") as! CheckrFormViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}

extension OptionViewController:OptionWebViewDelegate
{
    func addTomyProfile() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            if self.refBalance > self.amount {
                self.paymentWithRefBalance()
            }else{
                self.showPaymentPopup(amount: "\(self.amount)")
                
            }
        }
        
    }
    
    
}

extension OptionViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableCell", for: indexPath) as! OptionTableCell
        cell.lblText.text = optionArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = Mainstoryboard.instantiateViewController(withIdentifier: "CheckrFormViewController") as! CheckrFormViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


class OptionTableCell : UITableViewCell{
    @IBOutlet weak var lblText : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblText.layer.cornerRadius = 6
        lblText.layer.borderWidth = 0.5
        lblText.layer.borderColor = UIColor.gray.cgColor
        
        
    }
    
}


extension OptionViewController : AcceptOfferPaymentDelegate, PaymentNewCardForOfferAccept{
    func doneAction(paymentMode: String, paymentType: String) {
        if paymentMode == "sucess"{
            let vc = Mainstoryboard.instantiateViewController(withIdentifier: "CheckrFormViewController") as! CheckrFormViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func selectPayment(paymentMode: String, PaymentMethoda: String, PaymentType: String, selectedPromoJson: JSON?, selectedCode: String?) {
        self.promoCode = selectedCode ?? ""
        self.selectedPromoJson = selectedPromoJson
        if paymentMode == "sucess"{
            
            let vc = Mainstoryboard.instantiateViewController(withIdentifier: "CheckrFormViewController") as! CheckrFormViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if paymentMode == "NewCard"{
            let vc = SecondStoryboard.instantiateViewController(withIdentifier: "PayWithNewCardViewController") as! PayWithNewCardViewController
            vc.PaymentType = PaymentType
            vc.jobId = 0
            vc.ToUserId = 0
            vc.FromViewController = "ApplicationAccepted"
            vc.selectedPromoJson = self.selectedPromoJson
            vc.promoCode = self.promoCode
            vc.delegate = self
            vc.amount = "\(self.amount)"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}

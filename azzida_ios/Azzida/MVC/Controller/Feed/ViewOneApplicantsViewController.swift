//
//  ViewOneApplicantsViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 05/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class ViewOneApplicantsViewController: UIViewController {
    
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var tblActivity : UITableView!
    @IBOutlet weak var viewDetail : UIView!
    @IBOutlet weak var tblActivityHeight : NSLayoutConstraint!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblJobCompliteTitle: UILabel!
    @IBOutlet weak var lblJobComplite: UILabel!
    @IBOutlet weak var lblJoinedAzzidaTitle: UILabel!
    @IBOutlet weak var lblJoinedAzzida: UILabel!
    @IBOutlet weak var lblSkillsTitle: UILabel!
    @IBOutlet weak var lblSkills: UILabel!
    @IBOutlet weak var lblRecentActvity: UILabel!
    @IBOutlet weak var RateView: FloatRatingView!
    @IBOutlet weak var imgAzzidaVerified: UIImageView!
    
    var rating = 0
    var selectedName = ""
    var GetRecentActivityJSON : [JSON] = []
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let Constant : CommonStrings = CommonStrings.commonStrings
    var jobId = 0
    var SeekerId = 0
    var data: [JSON] = []
    var ApplicantDetails = JSON()
    let userModel : UserModel = UserModel.userModel
    var AmountWithAdminCharges = Double()
    var refBalance = Double()
    var promoCode = ""
    var promoList:[JSON] = []
    var selectedPromoJson:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RateView.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        tblActivity.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCell")
        
        tblActivity.rowHeight = UITableView.automaticDimension
        tblActivity.estimatedRowHeight = 120
        
        viewDetail.cellBGViewShdow()
        GetViewApplicantDetails()
        
        RateView.contentMode = UIView.ContentMode.scaleAspectFit
        RateView.type = .halfRatings
        RateView.isUserInteractionEnabled = false

        AmountWithAdminCharges = userModel.ListerJobData["AmountWithAdminCharges"].doubleValue
        refBalance = userModel.Balance.doubleValue
//        refBalance = 0
//        jobId = 0
    }
    override func viewWillAppear(_ animated: Bool) {
//        getUserProfile()
       
       
    }
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()
       }
    
    
    
    
    
    
    
    
    @IBAction func btnAccpet(_ sender: UIButton) {
        if refBalance > AmountWithAdminCharges {
            self.paymentWithRefBalance()
        }else{
            self.showPaymentPopup(amount: "\(AmountWithAdminCharges)")
            
        }
        //  applicationAccepted()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setText(){
        //   self.title = "My_Jobs".localized()
        self.lblSkillsTitle.text = "SkillsExperience".localized()
        self.lblJobComplite.text = "Jobs_Performed".localized()
        self.lblJoinedAzzidaTitle.text = "Joined_Azzida".localized()
        self.lblRecentActvity.text = "Recent_Activity".localized()
    }
    
    func applicationAccepted(){
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "ApplicationAccepted?JobId=\(jobId)&SeekerId=\(ApplicantDetails["SeekerId"].intValue)&ListerId=\(appDel.user_ID)&IsAcceptedByLister=true&applink=") { (responce) in
            if responce["message"].stringValue == "success"{
                
                DispatchQueue.main.async {
                    if self.userModel.UserMainActivity == "MyListHomeViewController" {
                        self.navigationController?.popToViewController(ofClass: MyListHomeViewController.self)
                    }else{
                        self.navigationController?.popToViewController(ofClass: HomeViewController.self)
                        
                    }
                    
                }
                
            }
        }
    }
    
    func GetViewApplicantDetails(){
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "SeekerId":SeekerId
        ]
        apiController.getRequest(methodName: "ViewApplicantDetail", param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success"{
                self.ApplicantDetails = responce["data"]
               // self.lblName.text = "\(responce["data"]["Fname"].stringValue) " +  responce["data"]["LName"].stringValue
                self.lblName.text = self.selectedName
                self.lblJobComplite.text = "\(responce["data"]["JobCompleteCount"].intValue)"
                var Joindate = responce["data"]["Joindate"].stringValue
                Joindate = Joindate.replacingOccurrences(of: "/Date(", with: "")
                Joindate = Joindate.replacingOccurrences(of: ")/", with: "")
                
                self.lblJoinedAzzida.text = CommonStrings.getFromatedDate(timeStamp: (Joindate as NSString).doubleValue)
                self.imgView.downloadImage(url: responce["data"]["UserProfile"].stringValue)
                self.lblSkills.text = responce["data"]["SkillExperience"].stringValue
                self.GetRecentActivityJSON = responce["data"]["GetRecentActivity"].arrayValue
                
                self.lblReview.text = "(\(responce["data"]["RatingUserCount"].intValue))"
                if(responce["data"]["ReportStatus"].stringValue == "clear")
                {
                    self.imgVerified.isHidden = false
                }
                else
                {
                    self.imgVerified.isHidden = true
                }
                
                DispatchQueue.main.async {
                    self.RateView.rating = responce["data"]["RateAvg"].doubleValue.rounded()
                    self.tblActivity.reloadData()
                    self.tblActivity.layoutIfNeeded()
                    self.tblActivityHeight.constant = self.tblActivity.contentSize.height
                }
            }
        }
    }
    

    func makePaymentWithRefBalance(){
        let apiController : APIController = APIController()
//        let testValue = "live"
//        let testValue = "test"
        apiController.postRequest(methodName: "CreatePayment?JobId=\(jobId)&UserId=\(self.appDel.user_ID)&ToUserId=\(SeekerId)&refbalance=\(refBalance)&CustomerId=\("")&TotalAmount=\(AmountWithAdminCharges)&PaymentToken=\("")&PaymentType=Payment&TokenUsed=\(AppTokenUsed.tokenUsed)") { (responce) in
            if responce["message"].stringValue == "success" {
                DispatchQueue.main.async {
                    self.applicationAccepted()
                }
            }
        }
    }

    func paymentWithRefBalance(){
        let alert = UIAlertController(title: "\n\nAmount debited from Referral Balance = \(AmountWithAdminCharges)\n", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.makePaymentWithRefBalance()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func showPaymentPopup(amount:String){
        let vc = SecondStoryboard.instantiateViewController(withIdentifier: "SelectPaymentViewController") as! SelectPaymentViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.PaymentType = "Payment"
        vc.amount = amount
        vc.jobId = jobId
        vc.paymentMsg = "true"
        vc.acceptOfferPaymentDelegate = self
        vc.ToUserId = SeekerId
        vc.FromViewController = "ApplicationAccepted"
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension ViewOneApplicantsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.GetRecentActivityJSON.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        cell.lblName.text = GetRecentActivityJSON[indexPath.row]["JobTitle"].stringValue
        cell.lblDetail.text = "Jobs Performed \(Date(milliseconds: GetRecentActivityJSON[indexPath.row]["CompletedDate"].intValue).timeAgo()) ago"
        cell.lblPrice.text = " $" + GetRecentActivityJSON[indexPath.row]["Amount"].stringValue + "  "

            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension ViewOneApplicantsViewController : AcceptOfferPaymentDelegate, PaymentNewCardForOfferAccept{
    func doneAction(paymentMode: String, paymentType: String) {
        if paymentMode == "sucess"{
            self.applicationAccepted()
        }
    }
    
    func selectPayment(paymentMode: String, PaymentMethoda: String, PaymentType: String, selectedPromoJson: JSON?, selectedCode: String?) {
        self.selectedPromoJson = selectedPromoJson
        self.promoCode = selectedCode ?? ""
        if paymentMode == "sucess"{
            self.applicationAccepted()
        }
        else if paymentMode == "NewCard"{
            let vc = SecondStoryboard.instantiateViewController(withIdentifier: "PayWithNewCardViewController") as! PayWithNewCardViewController
            vc.PaymentType = "Payment"
            vc.jobId = jobId
            vc.ToUserId = SeekerId
            vc.FromViewController = "ApplicationAccepted"
            vc.selectedPromoJson = self.selectedPromoJson
            vc.promoCode = self.promoCode
            vc.delegate = self
            vc.paymentMsg = "true"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}


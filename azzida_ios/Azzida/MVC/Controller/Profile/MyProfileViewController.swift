//
//  MyProfileViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 27/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import Kingfisher

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var viewPopupView: UIView!
    @IBOutlet weak var menuCollectionView : UICollectionView!
    @IBOutlet weak var tblActivity : UITableView!
    @IBOutlet weak var lblActivity : UILabel!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblBalance : UILabel!
    @IBOutlet weak var userImg : UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    @IBOutlet weak var imgVerified: UIImageView!
    //-----------------------Image below is Shown only if imgVerified is shown line no:79-------------------
    @IBOutlet weak var imgProfileVerified: UIImageView!
    
    var menuArr : [String] = []
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let userModel : UserModel = UserModel.userModel
    let constant : CommonStrings = CommonStrings.commonStrings
    var RecentActivityData : [JSON] = []
    var postJson : [JSON] = []
    var appliedJson : [JSON] = []
    var popUpView : Bool!
    var titleArr = ["Unload car full of groceries as I can not lift them","Cut the neighbors grass","Unload car full of groceries as I can not lift them","Cut the neighbors grass","Unload car full of groceries as I can not lift them","Cut the neighbors grass"]

    override func viewDidLoad() {
        super.viewDidLoad()
         
//    
//        popUpView = true
//        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
//               self.setText()
//        
//        self.menuCollectionView.register(UINib(nibName: "ProfileMenuViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileMenuViewCell")
//        
//        tblActivity.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCell")
//
//        tblActivity.rowHeight = UITableView.automaticDimension
//        tblActivity.estimatedRowHeight = 300
//        
//        //GetProfile()
//       
//        
//       // ratingView.delegate = self
//        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
//        ratingView.type = .halfRatings
//        ratingView.isUserInteractionEnabled = false
//
//        let selectAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
//        let normalAttribute = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
//
//        SegmentedControl.setTitleTextAttributes(selectAttribute, for: .selected)
//        SegmentedControl.setTitleTextAttributes(normalAttribute, for: .normal)

       // ratingView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popUpView = true
               NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
                      self.setText()
               
               self.menuCollectionView.register(UINib(nibName: "ProfileMenuViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileMenuViewCell")
               
               tblActivity.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCell")

               tblActivity.rowHeight = UITableView.automaticDimension
               tblActivity.estimatedRowHeight = 300
               
               //GetProfile()
              
               
              // ratingView.delegate = self
               ratingView.contentMode = UIView.ContentMode.scaleAspectFit
               ratingView.type = .halfRatings
               ratingView.isUserInteractionEnabled = false

               let selectAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
               let normalAttribute = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]

               SegmentedControl.setTitleTextAttributes(selectAttribute, for: .selected)
               SegmentedControl.setTitleTextAttributes(normalAttribute, for: .normal)
        SegmentedControl.selectedSegmentIndex = 0
        getUserProfile()
        GetRecentActivity()
        if appDel.user_ID == 0 {
            lblUserName.text = "Guest User"
            ratingView.rating = 0
        }else{
            userImg.downloadImage(url: userModel.ProfilePicture)
            lblUserName.text = "\(userModel.FirstName) \(userModel.LastName)"
            ratingView.rating = userModel.UserRatingAvg.rounded()
            lblBalance.text = "Available Balance : $\(userModel.Balance)"
            if(userModel.globalStatus == "clear" && userModel.nationalStatus == "clear" && userModel.ssnTraceStatus == "clear" && userModel.sexOffenderStatus == "clear")
            {
                self.imgVerified.isHidden = false
            }
            else
            {
                self.imgVerified.isHidden = true
            }
            
            //------------This Code is Updated--------------------------
           
            
        }
        
       
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setText(){
      //  menuArr = ["Edit_Profile".localized(),"Edit_Payment_Info".localized(),"My_Listings".localized(),"My_Jobs".localized(),"Payment_History".localized(),"Dispute_Resolution".localized()]
        
        
        menuArr = ["My_Jobs".localized(),"My_Listings".localized(),"Edit_Profile".localized(),"Dispute_Resolution".localized(),"Payment_History".localized(),"Edit_Payment_Info".localized(), "Cash_Out".localized()]
//        "Options".localized(),
        lblActivity.text = "Recent_Activity".localized()
      }
    
    
    func GetRecentActivity(){
        let apiConrroller : APIController = APIController()
        let param:[String:Any] = [
            "UserId":appDel.user_ID
        ]
        apiConrroller.getRequest(methodName: "GetRecentActivity", param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success"{
                self.postJson = responce["data"]["post"].arrayValue
                self.appliedJson = responce["data"]["applied"].arrayValue
                self.RecentActivityData = self.postJson
                DispatchQueue.main.async {
                    self.tblActivity.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func SegmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("post")
            self.RecentActivityData = self.postJson
        }
        else{
            print("applid")
            self.RecentActivityData = self.appliedJson
        }
        
        
        DispatchQueue.main.async {
            self.tblActivity.reloadData()
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        viewPopupView.isHidden = true
        popUpView = false
        pamentStripe()
        
    }
    @IBAction func closeAction(_ sender: Any) {
        viewPopupView.isHidden = true
        popUpView = false
    }
    
}


extension MyProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ProfileMenuDelegate{
    func menuTag(index: Int) {
        print(index)
        
        if appDel.user_ID == 0 {
            checkLogin.MovoToLogin(viewController: self)
            return
        }
        
        
        if index == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MyJobHomeViewController") as! MyJobHomeViewController
            userModel.JobTypeProfile = "My_Jobs"
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        if index == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MyListHomeViewController") as! MyListHomeViewController
            userModel.JobTypeProfile = "My_Listings"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if index == 2 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            vc.backBtn = "false"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        if index == 3 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DisputeViewController") as! DisputeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if index == 4 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentHistoryVC") as! PaymentHistoryVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if index == 5 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditPaymentViewController") as! EditPaymentViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        if index == 6
//        {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        if index == 6 {
            
            pamentStripe()
                
            
        }
    }
    func pamentStripe(){
        if appDel.user_ID == 0 {
                          return
                      }
                      
                      let apiController : APIController = APIController()
                      let param:[String:Any] = [
                          "UserId":appDel.user_ID
                      ]
                      apiController.getRequest(methodName: "GetProfile",param: param, isHUD: false) { (responce) in
                          if responce["message"].stringValue == "success" {
                            self.userModel.accountNumber = responce["data"]["StripeAccId"].stringValue
               
                            if(self.userModel.accountNumber != "")
                               {
                                self.cashout()
        }
        else{
                                if self.popUpView == true{
                                    self.viewPopupView.isHidden = false
            }
            else{
            let alert:UIAlertController = UIAlertController(title: "Stripe Payment", message: "Link or create a new account for job payment payouts to your account once you have completed the job", preferredStyle: .alert)
            let exisitingAccount:UIAlertAction = UIAlertAction(title: "Link exisiting account", style: .default) { (exisitingAction) in
                alert.dismiss(animated: false, completion: nil)
                let newAccountAlert:UIAlertController = UIAlertController(title: "Account number", message: "", preferredStyle: .alert)
                newAccountAlert.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Account No."
                }
                let closeAction:UIAlertAction = UIAlertAction(title: "Close", style: .destructive) { (closeAlertAction) in
                    newAccountAlert.dismiss(animated: true, completion: nil)
                }
                let okAction:UIAlertAction = UIAlertAction(title: "Submit", style: .default) { (okAlertAction) in
                    newAccountAlert.dismiss(animated: true, completion: nil)
                    let accountNoTextField = newAccountAlert.textFields![0] as UITextField
                    self.linkAccount(code: "", accountNumber: accountNoTextField.text!)
                }
                newAccountAlert.addAction(closeAction)
                newAccountAlert.addAction(okAction)
                
                self.present(newAccountAlert, animated: true, completion: nil)
            }
            
            let newAccount:UIAlertAction = UIAlertAction(title: "Create new account", style: .default) { (newAccountAction) in
                let webViewController:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                webViewController.delegate = self
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
            
            let skip:UIAlertAction = UIAlertAction(title: "Skip", style: .destructive) { (skipAction) in
                
            }
            
            alert.addAction(exisitingAccount)
            alert.addAction(newAccount)
            alert.addAction(skip)
            self.present(alert, animated: true, completion: nil)
        }    }
    }
        }
    }
    
    func cashout() {
        if(userModel.receivedAmount > 0)
        {
            print("cash out")
            let vc:PayoutViewController = self.storyboard?.instantiateViewController(withIdentifier: "PayoutViewController") as! PayoutViewController
            vc.accountId = userModel.stripeAccId
            vc.amount = "\(userModel.receivedAmount)"
            vc.userId = "\(userModel.Id)"
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        else
        {
            ServiceManager.alert(message: "Insufficient balance")
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
                self.userModel.reportStatus = responce["data"]["ReportStatus"].stringValue
                self.userModel.stripeAccId = responce["data"]["StripeAccId"].stringValue
                self.userModel.nationalStatus = responce["data"]["NationalStatus"].stringValue
                self.userModel.globalStatus = responce["data"]["GlobalStatus"].stringValue
                self.userModel.sexOffenderStatus = responce["data"]["SexOffenderStatus"].stringValue
                self.userModel.ssnTraceStatus = responce["data"]["SsnTraceStatus"].stringValue
                self.userModel.provider = responce["data"]["Provider"].stringValue
                if(self.userModel.reportStatus == "clear")
                {
                    self.imgProfileVerified.isHidden = false
                }
                else
                {
                    self.imgProfileVerified.isHidden = true
                }
            }
        }
        
    }
    
    func linkAccount(code:String, accountNumber:String) {
        //        http://13.72.77.167:8086/api/RetrieveStripeAccount?code=&userid=&accountnumber=
        let param : [String:Any] = ["code":code,"userid":userModel.Id,"accountnumber":accountNumber,"TokenUsed":AppTokenUsed.tokenUsed]
        
        print(param)
        let apiController : APIController = APIController()
        apiController.linkAccount(params: param, successHandler: { (json) in
            if json["message"].stringValue == "success"{
                self.userModel.stripeAccId = json["data"].stringValue
                self.cashout()
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileMenuViewCell", for: indexPath) as! ProfileMenuViewCell
        cell.btnMenu.setTitle(menuArr[indexPath.row], for: .normal)
        cell.parentVC = self
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.menuCollectionView.frame.width / 2 - 3, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
}

extension MyProfileViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if RecentActivityData.count == 0 {
            self.tblActivity.setEmptyMessage("No Recent Activity Found.")
        } else {
            self.tblActivity.restore()
        }
        

        
        return RecentActivityData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        cell.lblName.text = RecentActivityData[indexPath.row]["JobTitle"].stringValue
        cell.lblDetail.text = "\(CommonStrings.getActivityDate(timeStamp: RecentActivityData[indexPath.row]["FromDate"].doubleValue))"
      //  cell.lblDetail.text = "You completed \(Date(milliseconds: RecentActivityData[indexPath.row]["FromDate"].intValue).timeAgo()) ago"
        cell.lblPrice.text = " $" + RecentActivityData[indexPath.row]["Amount"].stringValue + "   "
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
        if RecentActivityData[indexPath.row]["UserId"].intValue == appDel.user_ID{
            let vc = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
            vc.jobID = RecentActivityData[indexPath.row]["Id"].intValue
           // vc.currantlat = self.currantlat
           // vc.currantlong = self.currantlong
            vc.titleStr = "Profile"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = SecondStoryboard.instantiateViewController(withIdentifier: "MyJobFeedViewController") as! MyJobFeedViewController
            vc.listJSON = RecentActivityData[indexPath.row]
            vc.jobID = RecentActivityData[indexPath.row]["Id"].intValue
           // vc.currantlat = self.currantlat
            //vc.currantlong = self.currantlong
            vc.titleStr = "Profile"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
    


extension MyProfileViewController:WebViewControllerDelegate
{
    func getAccount(code: String) {
        self.linkAccount(code: code, accountNumber: "")
    }
}

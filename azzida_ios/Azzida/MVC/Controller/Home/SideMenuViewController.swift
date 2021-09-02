//
//  SideMenuViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 27/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import Kingfisher

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var profileView : UIView!
    @IBOutlet weak var profileImg : UIImageView!
    @IBOutlet weak var userName : UILabel!
    var menuArr : [String] = []
    // var imagArr = [#imageLiteral(resourceName: "Side-Navigaiton-Profile"),#imageLiteral(resourceName: "Side-Navigaiton-Mylisting"),#imageLiteral(resourceName: "Side-Navigaiton-MyJobs"),#imageLiteral(resourceName: "Side-Navigaiton-About"),#imageLiteral(resourceName: "Side-Navigaiton-FAQ"),#imageLiteral(resourceName: "side_navigaiton_share"),#imageLiteral(resourceName: "side_navigaiton_logout")]
    var imagArr = [#imageLiteral(resourceName: "Side-Navigaiton-Profile"),#imageLiteral(resourceName: "Side-Navigaiton-MyJobs"),#imageLiteral(resourceName: "Side-Navigaiton-About"),#imageLiteral(resourceName: "Side-Navigaiton-FAQ"),#imageLiteral(resourceName: "side_navigaiton_stripe"),#imageLiteral(resourceName: "side_navigaiton_share"),#imageLiteral(resourceName: "side_navigaiton_logout")]
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let userModel : UserModel = UserModel.userModel
    let constant : CommonStrings = CommonStrings.commonStrings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        tblView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewMyProfile))
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(tap)
        
        
        if appDel.user_ID == 0 {
            userName.text = "Guest User"
        }else{
            profileImg.downloadImage(url: userModel.ProfilePicture)
            userName.text = "\(userModel.FirstName) \(userModel.LastName)"
        }
        //        let url = URL(string: constant.appImageBaseUrl + userModel.ProfilePicture)
        //        profileImg.kf.setImage(with: url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func profileTapAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    @objc func setText(){
        // menuArr = ["Profile".localized(),"My_Listing".localized(),"My_Jobs".localized(),"About".localized(),"FAQ".localized(),"Contact_Us".localized(),"Logout".localized(),"Terms_and_Conditions".localized(),"Dispute_Resolution_Policy".localized(),"Privacy_Policy".localized()]
        
        if appDel.user_ID == 0 {
            imagArr = [#imageLiteral(resourceName: "Side-Navigaiton-Profile"),#imageLiteral(resourceName: "Side-Navigaiton-MyJobs"),#imageLiteral(resourceName: "Side-Navigaiton-About"),#imageLiteral(resourceName: "Side-Navigaiton-FAQ"),#imageLiteral(resourceName: "side_menu_option"),#imageLiteral(resourceName: "side_navigaiton_stripe"),#imageLiteral(resourceName: "side_navigaiton_share"),#imageLiteral(resourceName: "icons_Login")]
            
            menuArr = ["Profile".localized(),"Jobs_Feed".localized(),"About".localized(),"FAQ".localized(),"Setup Stripe".localized(),"Share".localized(),"Login".localized(),"Terms_and_Conditions".localized(),"Fees_and_Charges".localized(),"Privacy_Policy".localized(),"Follow".localized()]
//            "Options".localized(),
        }
        else{
            menuArr = ["Profile".localized(),"Jobs_Feed".localized(),"About".localized(),"FAQ".localized(),"Setup Stripe".localized(),"Share".localized(),"Logout".localized(),"Terms_and_Conditions".localized(),"Fees_and_Charges".localized(),"Privacy_Policy".localized(),"Follow".localized()]
//            "Options".localized(),
        }
        
    }
    
    @objc func viewMyProfile(sender:UITapGestureRecognizer) {
        //        let vc = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        //        self.navigationController?.pushViewController(vc, animated:true)
    }
    func pamentStripe(){
        
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "UserId":appDel.user_ID
        ]
        apiController.getRequest(methodName: "GetProfile",param: param, isHUD: false) { (responce) in
            if responce["message"].stringValue == "success" {
                self.userModel.accountNumber = responce["data"]["StripeAccId"].stringValue
                print(self.userModel.accountNumber)
                if(self.userModel.accountNumber != "")
                {
                    self.cashout()
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
                        webViewController.delegate = self as? WebViewControllerDelegate
                        self.navigationController?.pushViewController(webViewController, animated: true)
                    }
                    
                    let skip:UIAlertAction = UIAlertAction(title: "Skip", style: .destructive) { (skipAction) in
                        
                    }
                    
                    alert.addAction(exisitingAccount)
                    alert.addAction(newAccount)
                    alert.addAction(skip)
                    self.present(alert, animated: true, completion: nil)
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
//                self.cashout()
            }
        })
    }
    
    func cashout() {
//        if(userModel.receivedAmount > 0)
//        {
//            print("cash out")
//            let vc:PayoutViewController = self.storyboard?.instantiateViewController(withIdentifier: "PayoutViewController") as! PayoutViewController
//            vc.accountId = userModel.stripeAccId
//            vc.amount = "\(userModel.receivedAmount)"
//            vc.userId = "\(userModel.Id)"
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true, completion: nil)
//        }
//        else
//        {
            ServiceManager.alert(message: "Stripe account already exists")
//        }
    }
    
    
    
    
    
}





extension SideMenuViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 7{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
            cell.iconMenu.image = imagArr[indexPath.row]
            cell.lblMenu.text = menuArr[indexPath.row]
            
            if indexPath.row == imagArr.count-1{
                cell.lineView.isHidden = false
                
            }else{
                cell.lineView.isHidden = true
            }
            
            
            
            return cell
        }
        
        if indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9{
            
            let  cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            cell.textLabel?.text = menuArr[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuFollowViewCell", for: indexPath) as! SideMenuFollowViewCell
        
        let tapInsta = UITapGestureRecognizer(target: self, action: #selector(self.openInsta))
        cell.imgInsta.isUserInteractionEnabled = true
        cell.imgInsta.addGestureRecognizer(tapInsta)
        
        let tapFB = UITapGestureRecognizer(target: self, action: #selector(self.openFB))
        cell.imgFacebook.isUserInteractionEnabled = true
        cell.imgFacebook.addGestureRecognizer(tapFB)
        
        let tapTwitter = UITapGestureRecognizer(target: self, action: #selector(self.openTwitter))
        cell.imgTwitter.isUserInteractionEnabled = true
        cell.imgTwitter.addGestureRecognizer(tapTwitter)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
        
        //Profile
        if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vc, animated:true)
        }
        
        //My JOb
        if indexPath.row == 1 {
            //            if appDel.user_ID == 0 {
            //                checkLogin.MovoToLoginFromSideMenu(viewController: self)
            //            }else{
            appDel.JobType = "JobFeed"
            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(vc, animated:true)
            // }
        }
        
        //About
        if indexPath.row == 2 {
            
            guard let url = URL(string: "https://azzida.com/odd_jobs/about_azzida/") else { return }
            UIApplication.shared.open(url)
            
        }
        
        //FA@
        if indexPath.row == 3 {
            
            guard let url = URL(string: "http://azzida.com/odd_jobs/frequently-asked-questions/") else { return }
            UIApplication.shared.open(url)
            
        }
        
//        if indexPath.row == 4 {
//            if appDel.user_ID == 0 {
//                checkLogin.MovoToLoginFromSideMenu(viewController: self)
//            }
//            else{
//                let vc = storyboard?.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
//                self.navigationController?.pushViewController(vc, animated:true)
//            }
//
//        }
        if indexPath.row == 4 {
            if appDel.user_ID == 0 {
                checkLogin.MovoToLoginFromSideMenu(viewController: self)
            }
            else{
                pamentStripe()
            }
        }
        
        //share
        if indexPath.row == 5 {
            var textShare = ""
            
            if appDel.user_ID == 0 {
                textShare = """
                Let me recommend you this application
                
                https://apps.apple.com/us/app/Azzida/id1534894647
                """
            }
            else
            {
                textShare = """
                Check out this new app for getting stuff done
                
                https://apps.apple.com/us/app/Azzida/id1534894647
                Use Code for SignUp \(userModel.RefCode)
                """
            }
            
            if UIDevice.current.localizedModel == "iPhone" {
                let ac = UIActivityViewController(activityItems: [textShare], applicationActivities: nil)
                print(ac)
                self.present(ac, animated: true)
            } else if UIDevice.current.localizedModel == "iPad" {
                let activityVC = UIActivityViewController(activityItems: [textShare], applicationActivities: nil)
                activityVC.title = "Share"
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                if let popoverController = activityVC.popoverPresentationController {
                    print(UIScreen.main.bounds.height)
                    print(UIScreen.main.bounds.width)
                    popoverController.sourceRect = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height / 2)
                    popoverController.sourceView = self.view
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                }
                
                self.present(activityVC, animated: true, completion: nil)
            }
        }
        
        if indexPath.row == 6 {
            if appDel.user_ID == 0 {
                PopRootFromSideMenu()
            }else{
                logOut()
            }
        }
        
        // Terms And Conditions
        if indexPath.row == 7 {
            guard let url = URL(string: "http://azzida.com/odd_jobs/azzida-terms-of-use/") else { return }
            UIApplication.shared.open(url)
            
        }
        
        // Fees And charges
        if indexPath.row == 8 {
            guard let url = URL(string: "http://azzida.com/odd_jobs/fee-charges/") else { return }
            UIApplication.shared.open(url)
            
        }
        
        // Privacy policy
        if indexPath.row == 9 {
            guard let url = URL(string: "http://azzida.com/odd_jobs/azzida-privacy-policy/") else { return }
            UIApplication.shared.open(url)
            
        }
    }
    
    
    
    
    func logOut(){
        let refreshAlert = UIAlertController(title: "Are You Sure to LogOut ? ", message: "", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "login_Id")
            UserDefaults.standard.synchronize()
            self.logOutApi()
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 10 {
            return 96
        }
        return 50
    }
    
    func PopRootFromSideMenu(){
        
        let navigationController = self.presentingViewController as? UINavigationController
        
        self.dismiss(animated: true) {
            let _ = navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    
    func logOutApi(){
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "Logout?UserId=\(appDel.user_ID)") { (responce) in
            if responce["message"].stringValue == "success"{
                DispatchQueue.main.async {
                    let navigationController = self.presentingViewController as? UINavigationController
                    
                    self.dismiss(animated: true) {
                        let _ = navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
        
    }
    
    @objc func openInsta(sender:UITapGestureRecognizer) {
        let Username =  "Azzida_App" // Your Instagram Username here
        let appURL = URL(string: "instagram://user?username=\(Username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: "https://www.instagram.com/azzida_app/")!
            application.open(webURL)
        }
        
    }
    
    @objc func openFB(sender:UITapGestureRecognizer) {
        guard let url = URL(string: "https://www.facebook.com/azzidaapp") else { return }
        UIApplication.shared.open(url)
        
    }
    
    @objc func openTwitter(sender:UITapGestureRecognizer) {
        guard let url = URL(string: "https://linkedin.com/companies/azzida") else { return }
        UIApplication.shared.open(url)
    }
    
}

extension SideMenuViewController:WebViewControllerDelegate
{
    func getAccount(code: String) {
        self.linkAccount(code: code, accountNumber: "")
    }
}


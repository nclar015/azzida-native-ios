//
//  SignUpViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 27/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
class SignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPssword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblOrSignUP: UILabel!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var lblAlredyHaveAccount: UILabel!
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var btnAcceptTerms: UIButton!
    @IBOutlet weak var txtReferalCode: UITextField!
    var useremail = ""
    var username = ""
    var AccessToekn = ""
    var usernameLast = ""
    var usernameFirst = ""
    let constant : CommonStrings = CommonStrings.commonStrings
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let loginManager = LoginManager()
    var firstName : String!
    let userModel : UserModel = UserModel.userModel
    var imageView = UIImageView()
    var emailId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Localize.setCurrentLanguage("en")
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        let LoginTap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        lblAlredyHaveAccount.isUserInteractionEnabled = true
        lblAlredyHaveAccount.addGestureRecognizer(LoginTap)
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtUserName.delegate = self
        txtPssword.delegate = self
        
        txtPssword.isSecureTextEntry = true
        btnEye.setImage(#imageLiteral(resourceName: "eye_hide"), for: .normal)
        setTermsString()
        self.btnSignUp.isEnabled = false
        btnSignUp.backgroundColor = UIColor.lightGray
        //--------------This code is Updated------------
        if(traitCollection.userInterfaceStyle == .dark){
            btnGoogle.setTitleColor(UIColor.white, for: .normal)
            btnFacebook.setTitleColor(UIColor.white, for: .normal)
        }else if(traitCollection.userInterfaceStyle == .light){
            btnGoogle.setTitleColor(UIColor.black, for: .normal)
            btnFacebook.setTitleColor(UIColor.black, for: .normal)
            
        }else if(traitCollection.userInterfaceStyle == .unspecified){
            btnGoogle.setTitleColor(UIColor.black, for: .normal)
            btnFacebook.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        BGView.addShdow()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func setText(){
        lblWelcome.text = "Welcome_To_Azzida".localized()
        lblSignUp.text = "SignUp".localized()
        lblOrSignUP.text = "OrSignUpwith".localized()
        btnSignUp.setTitle("SignUp".localized(), for: .normal)
        btnFacebook.setTitle("Facebook".localized(), for: .normal)
        btnGoogle.setTitle("Google".localized(), for: .normal)
        attributString()
    }
    
    func attributString(){
        if(traitCollection.userInterfaceStyle == .dark){
            let Already_have_anaccount = NSAttributedString(string:"Already_have_anaccount".localized(),
                                                            attributes:[NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            
            let Login = NSAttributedString(string:"Login_".localized(),
                                           attributes:[NSAttributedString.Key.foregroundColor:  constant.theamColor,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            let combination = NSMutableAttributedString()
            combination.append(Already_have_anaccount)
            combination.append(Login)
            
            lblAlredyHaveAccount.attributedText = combination
            txtFirstName.changePlaceHolder(text: "FirstName".localized())
            txtLastName.changePlaceHolder(text: "Last_Name".localized())
            txtUserName.changePlaceHolder(text: "UserName".localized())
            txtEmail.changePlaceHolder(text: "Email".localized())
            txtPssword.changePlaceHolder(text: "Password".localized())
            txtReferalCode.changePlaceHolder(text: "Referral code (optional)")
        }
        else
        {
            let Already_have_anaccount = NSAttributedString(string:"Already_have_anaccount".localized(),
                                                            attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            
            let Login = NSAttributedString(string:"Login_".localized(),
                                           attributes:[NSAttributedString.Key.foregroundColor:  constant.theamColor,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            let combination = NSMutableAttributedString()
            combination.append(Already_have_anaccount)
            combination.append(Login)
            
            lblAlredyHaveAccount.attributedText = combination
            txtFirstName.changePlaceHolder(text: "FirstName".localized())
            txtLastName.changePlaceHolder(text: "Last_Name".localized())
            txtUserName.changePlaceHolder(text: "UserName".localized())
            txtEmail.changePlaceHolder(text: "Email".localized())
            txtPssword.changePlaceHolder(text: "Password".localized())
            txtReferalCode.changePlaceHolder(text: "Referral code (optional)")
        }
        
    }
    
    @IBAction func btnAcceptTerms(_ sender: UIButton) {
        if (sender.isSelected == true)
        {
            sender.setBackgroundImage(UIImage(named: "Filter_unchecked"), for: .normal)
            btnSignUp.isEnabled = false
            btnSignUp.backgroundColor = UIColor.lightGray
            sender.isSelected = false;
        }
        else
        {
            sender.setBackgroundImage(UIImage(named: "Filter_checked"), for: .normal)
            btnSignUp.isEnabled = true
            btnSignUp.backgroundColor = constant.theamBlueColor
            sender.isSelected = true;
        }
        
    }
    
    @IBAction func btnApple(_ sender: Any) {
        //        let button = ASAuthorizationAppleIDButton()
        if #available(iOS 13.0, *) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            
            controller.delegate = self
            controller.presentationContextProvider = self
            
            controller.performRequests()
        }
    }
    
    @IBAction func btnFacebook(_ sender: UIButton) {
        // Localize.setCurrentLanguage("en")
        // loginManager.loginBehavior = .web
        loginManager.logIn(permissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            
            if error != nil
            {
                print("error occured with login \(String(describing: error?.localizedDescription))")
            }
            else if (result?.isCancelled)!
            {
                print("login canceled")
            }
            
            else
            {
                if AccessToken.current != nil
                {
                    print(AccessToken.current ?? "")
                    GraphRequest.init(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, userResult, error) in
                        if error != nil
                        {
                            print("error occured \(String(describing: error?.localizedDescription))")
                        }
                        else if userResult != nil
                        {
                            print("Login with FB is success")
                            print(userResult! as Any)
                            let response:[String:Any] = userResult as! [String:Any]
                            self.AccessToekn = "\(response["id"] ?? "")"
                            self.useremail = "\(response["email"] ?? "")"
                            self.username = "\(response["name"] ?? "")"
                            self.usernameFirst = "\(response["first_name"] ?? "")"
                            self.usernameLast = "\(response["last_name"] ?? "")"
                            print(self.useremail)
                            if self.useremail == ""{
                                
                            }else{
                                UserDefaults.standard.set(self.useremail, forKey: "UserEmailId")
                                UserDefaults.standard.synchronize()
                            }
                            
                            self.loginWithFBGoogle(Provider: "Facebook")
                            
                        }
                    })
                }
            }
        }
        
    }
    
    @IBAction func btnGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func loginWithFBGoogle(Provider:String){
        //        let params : [String:Any] = ["Email":self.useremail,"UserName":self.username,"TokenId":self.AccessToekn,"deviceId":"","devicetype":"","Provider":""]
        
        
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
        }else{
            UserDefaults.standard.set("", forKey: "token")
            UserDefaults.standard.synchronize()
        }
        let DeviceId = UserDefaults.standard.value(forKey: "token") as! String
       
        if Provider == "Facebook"
        {
             emailId =  UserDefaults.standard.value(forKey: "UserEmailId") as! String
        }
        else{
            emailId = self.useremail
        }
        
        
        
        
        print(emailId)
            
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "FacebookGoogleLogin?Email=\(emailId)&UserName=\(self.username)&TokenId=\(self.AccessToekn)&deviceId=\(DeviceId)&devicetype=iphone&Provider=\(Provider)") { (responce) in
            
            if responce["message"].stringValue == "success"{
                self.appDelegate.user_ID = responce["data"]["Id"].intValue
                self.firstName = responce["data"]["FirstName"].stringValue
                self.userModel.FirstName = responce["data"]["FirstName"].stringValue
                self.userModel.LastName = responce["data"]["LastName"].stringValue
//                self.firstName =  self.usernameFirst
//                self.userModel.FirstName = self.usernameFirst
//                self.userModel.LastName =  self.usernameLast
                self.userModel.ProfilePicture = responce["data"]["ProfilePicture"].stringValue
                self.userModel.UserEmail =  responce["data"]["UserEmail"].stringValue
                self.userModel.RefCode = responce["data"]["RefCode"].stringValue
                UserDefaults.standard.set(self.appDelegate.user_ID, forKey: "login_Id")
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async {
                    self.loginAlert(msg: "Login_Successful".localized())
                    
                }
            }
        }
    }
    func loginAlert(msg:String){
        let alert = UIAlertController(title: msg, message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            if self.firstName == ""{
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
//                vc.backBtn = "true"
//                vc.saveDetails = "true"
//                self.navigationController?.pushViewController(vc, animated:true)
//
                
                if self.userModel.ProfilePicture == ""{
                    self.imageView.downloadImage(url: "http://13.72.77.167:8088/ApplicationImages/defaultimage.png")
                }
                
                else{
                    self.imageView.downloadImage(url: self.userModel.ProfilePicture)
                }
                let param : [String:Any] = ["Id":"\(self.appDelegate.user_ID)","RoleId":"2","FirstName":self.usernameFirst,"LastName":self.usernameLast,"UserPassword":"","UserEmail":self.useremail ,"Skills":"","DeviceId":"","DeviceType":"iPhone","EmailType":"","Image":"","UserName":"","JobType":"","ReferalCode":self.userModel.RefCode]
                print(param)
                let apiController : APIController = APIController()
                apiController.EditProfile(params: param, image: self.imageView.image!) { (responce) in
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
                        self.userModel.stripeAccId = responce["data"]["StripeAccId"].stringValue
                        self.userModel.JobTypeCategory =  responce["data"]["JobType"].stringValue
                        self.userModel.nationalStatus = responce["data"]["NationalStatus"].stringValue
                        self.userModel.globalStatus = responce["data"]["GlobalStatus"].stringValue
                        self.userModel.sexOffenderStatus = responce["data"]["SexOffenderStatus"].stringValue
                        self.userModel.ssnTraceStatus = responce["data"]["SsnTraceStatus"].stringValue
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(vc, animated:true)
                    }
                }
                
                
                
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(vc, animated:true)
            }
        }
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        if !isValid(){
            return
        }
        self.signup()
        
        
    }
    
    func linkAccount(code:String, accountNumber:String) {
        //        http://13.72.77.167:8086/api/RetrieveStripeAccount?code=&userid=&accountnumber=
        let param : [String:Any] = ["code":code,"userid":"2","accountnumber":accountNumber,"TokenUsed":AppTokenUsed.tokenUsed]
        
        
        let apiController : APIController = APIController()
        apiController.linkAccount(params: param, successHandler: { (json) in
            if json["message"].stringValue == "success"{
                DispatchQueue.main.async {
                    self.signUpAlert(msg: "We have sent a verification email to your email id, please verify and login to app.")
                }
                
            }
        })
    }
    
    func signup() {
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
        }else{
            UserDefaults.standard.set("", forKey: "token")
            UserDefaults.standard.synchronize()
        }
        let DeviceId = UserDefaults.standard.value(forKey: "token") as! String
        
        
        let param : [String:Any] = ["Id":"0","RoleId":"2","FirstName":txtFirstName.text ?? "","LastName":txtLastName.text ?? "","UserPassword":txtPssword.text ?? "","UserEmail":txtEmail.text ?? "","Skills":"","DeviceId":"\(DeviceId)","DeviceType":"iPhone","EmailType":"other","Image":"","UserName":txtUserName.text ?? "","ReferalCode":txtReferalCode.text ?? ""]
        
        print(param)
        let apiController : APIController = APIController()
        apiController.signUp(params: param) { (responce) in
            
            if responce["message"].stringValue == "success"{
                self.appDelegate.user_ID = responce["data"]["Id"].intValue
                self.firstName = responce["data"]["FirstName"].stringValue
                self.userModel.FirstName = responce["data"]["FirstName"].stringValue
                self.userModel.LastName = responce["data"]["LastName"].stringValue
                self.userModel.ProfilePicture = responce["data"]["ProfilePicture"].stringValue
                self.userModel.UserEmail =  responce["data"]["UserEmail"].stringValue
                self.userModel.RefCode = responce["data"]["RefCode"].stringValue
                //                UserDefaults.standard.set(self.appDelegate.user_ID, forKey: "login_Id")
                //                UserDefaults.standard.synchronize()
                /*let alert:UIAlertController = UIAlertController(title: "Stripe Payment", message: "Link account or create new account", preferredStyle: .alert)
                 let exisitingAccount:UIAlertAction = UIAlertAction(title: "Link exisiting account", style: .default) { (exisitingAction) in
                 alert.dismiss(animated: false, completion: nil)
                 let newAccountAlert:UIAlertController = UIAlertController(title: "Account number", message: "", preferredStyle: .alert)
                 newAccountAlert.addTextField { (textField : UITextField!) -> Void in
                 textField.placeholder = "Account No."
                 }
                 let okAction:UIAlertAction = UIAlertAction(title: "Submit", style: .default) { (okAlertAction) in
                 newAccountAlert.dismiss(animated: true, completion: nil)
                 let accountNoTextField = newAccountAlert.textFields![0] as UITextField
                 self.linkAccount(code: "", accountNumber: accountNoTextField.text!)
                 }
                 let closeAction:UIAlertAction = UIAlertAction(title: "Close", style: .destructive) { (closeAlertAction) in
                 newAccountAlert.dismiss(animated: true, completion: nil)
                 }
                 newAccountAlert.addAction(okAction)
                 newAccountAlert.addAction(closeAction)
                 self.present(newAccountAlert, animated: true, completion: nil)
                 }
                 
                 let newAccount:UIAlertAction = UIAlertAction(title: "Create new account", style: .default) { (newAccountAction) in
                 let webViewController:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                 webViewController.delegate = self
                 self.navigationController?.pushViewController(webViewController, animated: true)
                 }
                 
                 let skip:UIAlertAction = UIAlertAction(title: "Skip", style: .destructive) { (skipAction) in
                 DispatchQueue.main.async {
                 self.signUpAlert(msg: "We have sent a verification email to your email id, please verify and login to app.")
                 }
                 }
                 
                 alert.addAction(exisitingAccount)
                 alert.addAction(newAccount)
                 alert.addAction(skip)
                 self.present(alert, animated: true, completion: nil)*/
                
                DispatchQueue.main.async {
                    self.signUpAlert(msg: "We have sent a verification email to your email id, please verify and login to app.")
                }
            }
        }
    }
    
    func signUpAlert(msg:String){
        //        let alert = UIAlertController(title: msg, message: "", preferredStyle: .alert)
        //        self.present(alert, animated: true, completion: nil)
        //                let when = DispatchTime.now() + 1
        //        DispatchQueue.main.asyncAfter(deadline: when){
        //            alert.dismiss(animated: true, completion: nil)
        //            self.navigationController?.popViewController(animated: true)
        ////            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        ////                self.navigationController?.pushViewController(vc, animated:true)
        //        }
        
        let refreshAlert = UIAlertController(title: msg, message: "", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnEye(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "eye_hide"){
            txtPssword.isSecureTextEntry = false
            sender.setImage(#imageLiteral(resourceName: "eye_show"), for: .normal)
        }
        else{
            txtPssword.isSecureTextEntry = true
            sender.setImage(#imageLiteral(resourceName: "eye_hide"), for: .normal)
        }
    }
    
    func isValid() -> Bool{
        if (txtFirstName.text!.isEmpty){
            Alert.alert(message:"Please_enter_First_Name".localized(), title: "Alert")
            return false
        }
        
        if (txtLastName.text!.isEmpty){
            Alert.alert(message:"Please_enter_last_Name".localized(), title: "Alert")
            return false
        }
        if (txtEmail.text!.isEmpty){
            Alert.alert(message:"Please_enter_Email".localized(), title: "Alert")
            return false
        }
        
        if !isValidEmail(txtEmail.text!){
            Alert.alert(message:"Please_enterValidEmail_address".localized(), title: "Alert")
            return false
            
        }
        
        if (txtUserName.text!.isEmpty){
            Alert.alert(message:"Please_enter_UserName".localized(), title: "Alert")
            return false
        }
        
        if (txtPssword.text!.isEmpty){
            Alert.alert(message:"Please_enter_Password".localized(), title: "Alert")
            return false
        }
        
        if !btnAcceptTerms.isSelected{
            Alert.alert(message: "Please Accept Terms of Use & Privacy Policy.", title: "Alert")
            return false
        }
        
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setTermsString(){
        if(traitCollection.userInterfaceStyle == .dark){
            
            
            let agree = NSAttributedString(string:"I have read and agree to the Azzida",
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.white,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 16) as Any])
            
            let Terms = NSAttributedString(string:"\nTerms of Use",
                                           attributes:[NSAttributedString.Key.foregroundColor: constant.theamBlueColor,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 17) as Any,
                                                       NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
            
            let space = NSAttributedString(string:" & ",
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.white,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            
            
            let Policy = NSAttributedString(string:"Privacy Policy",
                                            attributes:[NSAttributedString.Key.foregroundColor: constant.theamBlueColor,
                                                        NSAttributedString.Key.font: UIFont(name: "Arial", size: 17) as Any,
                                                        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
            
            let combination = NSMutableAttributedString()
            combination.append(agree)
            combination.append(Terms)
            combination.append(space)
            combination.append(Policy)
            
            lblTerms.attributedText = combination
            lblTerms.isUserInteractionEnabled = true
            lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
            
            
            
        }else if(traitCollection.userInterfaceStyle == .light){
            let agree = NSAttributedString(string:"I have read and agree to the Azzida",
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 16) as Any])
            
            let Terms = NSAttributedString(string:"\nTerms of Use",
                                           attributes:[NSAttributedString.Key.foregroundColor: constant.theamBlueColor,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 17) as Any,
                                                       NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
            
            let space = NSAttributedString(string:" & ",
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            
            
            let Policy = NSAttributedString(string:"Privacy Policy",
                                            attributes:[NSAttributedString.Key.foregroundColor: constant.theamBlueColor,
                                                        NSAttributedString.Key.font: UIFont(name: "Arial", size: 17) as Any,
                                                        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
            
            let combination = NSMutableAttributedString()
            combination.append(agree)
            combination.append(Terms)
            combination.append(space)
            combination.append(Policy)
            
            lblTerms.attributedText = combination
            lblTerms.isUserInteractionEnabled = true
            lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
            
        }else{
            let agree = NSAttributedString(string:"I have read and agree to the Azzida",
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 16) as Any])
            
            let Terms = NSAttributedString(string:"\nTerms of Use",
                                           attributes:[NSAttributedString.Key.foregroundColor: constant.theamBlueColor,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 17) as Any,
                                                       NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
            
            let space = NSAttributedString(string:" & ",
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            
            
            let Policy = NSAttributedString(string:"Privacy Policy",
                                            attributes:[NSAttributedString.Key.foregroundColor: constant.theamBlueColor,
                                                        NSAttributedString.Key.font: UIFont(name: "Arial", size: 17) as Any,
                                                        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
            
            let combination = NSMutableAttributedString()
            combination.append(agree)
            combination.append(Terms)
            combination.append(space)
            combination.append(Policy)
            
            lblTerms.attributedText = combination
            lblTerms.isUserInteractionEnabled = true
            lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
            
        }
        
        
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        guard let text = self.lblTerms.text else { return }
        let privacyPolicyRange = (text as NSString).range(of: "Terms of Use")
        if gesture.didTapAttributedTextInLabel(label: self.lblTerms, inRange: privacyPolicyRange) {
            guard let url = URL(string: "http://azzida.com/odd_jobs/azzida-terms-of-use/") else { return }
            UIApplication.shared.open(url)
            
        }else{
            guard let url = URL(string: "http://azzida.com/odd_jobs/azzida-privacy-policy/") else { return }
            UIApplication.shared.open(url)
            
        }
    }
    
}


extension SignUpViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        }
        else if textField == txtLastName {
            txtEmail.becomeFirstResponder()
        }
        else if textField == txtEmail{
            txtUserName.becomeFirstResponder()
        }
        else if textField == txtUserName{
            txtPssword.becomeFirstResponder()
        }
        else{
            txtPssword.resignFirstResponder()
        }
        
        return true
    }
}

extension SignUpViewController:WebViewControllerDelegate
{
    func getAccount(code: String) {
        self.linkAccount(code: code, accountNumber: "")
    }
}

extension SignUpViewController :GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //if any error stop and print the error
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        // print(user.profile.givenName)
        self.username = user.profile.name ?? ""
        self.useremail = user.profile.email ?? ""
        self.usernameLast = user.profile.familyName ?? ""
        self.usernameFirst = user.profile.givenName ?? ""
//        self.AccessToekn = user.authentication.accessToken
        self.AccessToekn = user.userID!
        self.loginWithFBGoogle(Provider: "Google")
    }
    
}

extension SignUpViewController: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        AccessToekn = appleIDCredential.user
        useremail = appleIDCredential.email ?? ""
        usernameFirst = appleIDCredential.fullName?.givenName ?? ""
        usernameLast = appleIDCredential.fullName?.familyName ?? ""
        username = usernameFirst + " " + usernameLast
        
        let result = String("User ID:\(AccessToekn)\nEmail:\(self.useremail)\nName:\(username)")
        print(result)
        UserDefaults.standard.set(AccessToekn, forKey: "userIdentifier1")
        
        let DeviceId = UserDefaults.standard.value(forKey: "token") as! String
        let Provider = "Apple"
     
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "FacebookGoogleLogin?Email=\(useremail)&UserName=\(username)&TokenId=\(AccessToekn)&deviceId=\(DeviceId)&devicetype=iphone&Provider=\(Provider)") { (responce) in
            
            if responce["message"].stringValue == "success"{
                self.appDelegate.user_ID = responce["data"]["Id"].intValue
                self.firstName = responce["data"]["FirstName"].stringValue
                self.userModel.FirstName = responce["data"]["FirstName"].stringValue
                self.userModel.LastName = responce["data"]["LastName"].stringValue
                self.userModel.ProfilePicture = responce["data"]["ProfilePicture"].stringValue
                self.userModel.UserEmail =  responce["data"]["UserEmail"].stringValue
                self.userModel.RefCode = responce["data"]["RefCode"].stringValue
                
                UserDefaults.standard.set(self.appDelegate.user_ID, forKey: "login_Id")
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async {
                    self.loginAlert(msg: "Login_Successful".localized())
                    
                }
            }
        }
//        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
extension SignUpViewController: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

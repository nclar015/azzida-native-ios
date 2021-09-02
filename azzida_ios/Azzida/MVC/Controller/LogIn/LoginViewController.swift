//
//  LoginViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 27/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
//import SkyFloatingLabelTextField
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtPssword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var BtnLogin: UIButton!
    @IBOutlet weak var lblOrLoginWith: UILabel!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var btnSkipLogin: UIButton!
    
    let userModel : UserModel = UserModel.userModel
    let constant : CommonStrings = CommonStrings.commonStrings
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let loginManager = LoginManager()
    var error : NSError?
    var useremail = ""
    var username = ""
    var usernameLast = ""
    var usernameFirst = ""
    var AccessToekn = ""
    var firstName : String!
    var emailId = ""
    var imageView = UIImageView() 
//    let imageView1 = UIImageView(image: UIImage(named: "no_profile.png")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        attributString()
        
        let signUpTap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        lblDontHaveAccount.isUserInteractionEnabled = true
        lblDontHaveAccount.addGestureRecognizer(signUpTap)
        
        txtUserName.delegate = self
        txtPssword.delegate = self
        btnEye.setImage(#imageLiteral(resourceName: "eye_hide"), for: .normal)
        
        if appDelegate.user_ID != 0 {
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else{
            DispatchQueue.main.async {
                self.SkipLogin()
            }
        }
        
        
        //        if error != nil{
        //            print(error ?? "google error")
        //            return
        //        }
        //
        //        //adding the delegates
        //        GIDSignIn.sharedInstance().presentingViewController = self
        //        GIDSignIn.sharedInstance().delegate = self
        //        GIDSignIn.sharedInstance().signIn()
        
        
        //------------------This Code is Updated------------
        if(traitCollection.userInterfaceStyle == .dark){
            btnForgotPass.backgroundColor = UIColor.black
            btnGoogle.setTitleColor(UIColor.white, for: .normal)
            btnFacebook.setTitleColor(UIColor.white, for: .normal)
        }else if(traitCollection.userInterfaceStyle == .light){
            btnForgotPass.backgroundColor = UIColor.white
            btnGoogle.setTitleColor(UIColor.black, for: .normal)
            btnFacebook.setTitleColor(UIColor.black, for: .normal)
        }else{
            btnForgotPass.backgroundColor = UIColor.white
            btnGoogle.setTitleColor(UIColor.black, for: .normal)
            btnFacebook.setTitleColor(UIColor.black, for: .normal)
        }
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        BGView.addShdow()
        btnSkipLogin.underline()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func setText(){
        
        lblWelcome.text = "Welcome_To_Azzida".localized()
        lblLogin.text = "Login".localized()
        lblOrLoginWith.text = "Or_Login_with".localized()
        btnForgotPass.setTitle("Forgot_Password".localized(), for: .normal)
        BtnLogin.setTitle("Login".localized(), for: .normal)
        btnFacebook.setTitle("Facebook".localized(), for: .normal)
        btnGoogle.setTitle("Google".localized(), for: .normal)
        
        txtUserName.changePlaceHolder(text: "UserName".localized())
        txtPssword.changePlaceHolder(text: "Password".localized())
        
        //        ApplyEffectOntextField(textField: txtUserName, title: "UserName".localized())
        //        ApplyEffectOntextField(textField: txtPssword, title: "Password".localized())
        
        
    }
    //    func ApplyEffectOntextField(textField:SkyFloatingLabelTextField,title: String){
    //        textField.title = title
    //        textField.tintColor = constant.theamColor // the color of the blinking cursor
    //        textField.textColor = UIColor.black
    ////        textField.lineColor = constant.theamColor
    //        textField.selectedTitleColor = constant.theamColor
    //
    //        textField.layer.borderWidth = 1
    //        textField.layer.cornerRadius = 4
    //        textField.layer.borderColor = UIColor.darkGray.cgColor
    //
    ////        textField.selectedLineColor = constant.theamColor
    //
    ////        textField.lineHeight = 1.0 // bottom line height in points
    ////        textField.selectedLineHeight = 2.0
    //    }
    
    func attributString(){
        if(traitCollection.userInterfaceStyle == .dark){
            let Dont_have_an_account = NSAttributedString(string:"Dont_have_an_account".localized(),
                                                          attributes:[NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                      NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            
            let SignUp = NSAttributedString(string:"SignUp_".localized(),
                                            attributes:[NSAttributedString.Key.foregroundColor:  constant.theamColor,
                                                        NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            let combination = NSMutableAttributedString()
            combination.append(Dont_have_an_account)
            combination.append(SignUp)
            
            lblDontHaveAccount.attributedText = combination
        }
        else
        {
            let Dont_have_an_account = NSAttributedString(string:"Dont_have_an_account".localized(),
                                                          attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                      NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            
            let SignUp = NSAttributedString(string:"SignUp_".localized(),
                                            attributes:[NSAttributedString.Key.foregroundColor:  constant.theamColor,
                                                        NSAttributedString.Key.font: UIFont(name: "Arial", size: 18) as Any])
            let combination = NSMutableAttributedString()
            combination.append(Dont_have_an_account)
            combination.append(SignUp)
            
            lblDontHaveAccount.attributedText = combination
        }
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
    
    @IBAction func btnApple(_ sender: Any) {
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
                    //  print(AccessToken.current)
                    self.AccessToekn = result?.token?.tokenString ?? ""
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
                            self.loginWithFBGoogle(Provider: "Facebook")
                            
                            
                            if self.useremail == ""{
                                
                            }else{
                                UserDefaults.standard.set(self.useremail, forKey: "UserEmailId")
                                UserDefaults.standard.synchronize()
                            }
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
    
    @IBAction func btnForgotPass(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    
    func SkipLogin(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //  appDelegate.JobType = "JobFeed"
        self.navigationController?.pushViewController(vc, animated:true)
        
    }
    
    @IBAction func btnSkipLogin(_ sender: UIButton) {
        SkipLogin()
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if !isValid(){
            return
        }
        
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
        }else{
            UserDefaults.standard.set("", forKey: "token")
            UserDefaults.standard.synchronize()
        }
        let DeviceId = UserDefaults.standard.value(forKey: "token") as! String
        
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "UserLogin?UserName=\(txtUserName.text ?? "")&UserPassword=\(txtPssword.text ?? "")&deviceId=\(DeviceId)&devicetype=iphone") { (responce) in
            if responce["message"].stringValue == "success"{
                self.appDelegate.user_ID = responce["data"]["Id"].intValue
                self.firstName = responce["data"]["FirstName"].stringValue
                self.userModel.FirstName = responce["data"]["FirstName"].stringValue
                self.userModel.LastName = responce["data"]["LastName"].stringValue
                self.userModel.ProfilePicture = responce["data"]["ProfilePicture"].stringValue
                self.userModel.UserEmail =  responce["data"]["UserEmail"].stringValue
                self.userModel.RefCode = responce["data"]["RefCode"].stringValue
                // self.appDelegate.JobType = "MyListing"
                
                UserDefaults.standard.set(self.appDelegate.user_ID, forKey: "login_Id")
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async {
                    self.loginAlert(msg: "Login_Successful".localized())
                    //  self.popUpController(token: DeviceId)
                }
            }
        }
    }
    
    
    func popUpController(token:String)
    {
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let margin:CGFloat = 8.0
        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 100.0)
        let customView = UITextView(frame: rect)
        
        customView.backgroundColor = UIColor.clear
        customView.font = UIFont(name: "Helvetica", size: 15)
        customView.text = token
        
        
        //  customView.backgroundColor = UIColor.greenColor()
        alertController.view.addSubview(customView)
        
        let somethingAction = UIAlertAction(title: "Something", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in print("something")
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:{})
        
        
    }
    
    
    func isValid() -> Bool{
        if (txtUserName.text!.isEmpty){
            Alert.alert(message:"Please_enter_UserName".localized(), title: "Alert")
            return false
        }
        
        if (txtPssword.text!.isEmpty){
            Alert.alert(message:"Please_enter_Password".localized(), title: "Alert")
            return false
        }
        
        return true
    }
    
    //FacebookGoogleLogin(string Email, string UserName,string TokenId, string deviceId, string device type, string Provider)
    
    func loginWithFBGoogle(Provider:String){
        
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
        
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "FacebookGoogleLogin?Email=\(self.useremail)&UserName=\(self.username)&TokenId=\(self.AccessToekn)&deviceId=\(DeviceId)&devicetype=iphone&Provider=\(Provider)") { (responce) in
            
            if responce["message"].stringValue == "success"{
                self.appDelegate.user_ID = responce["data"]["Id"].intValue
                self.firstName = responce["data"]["FirstName"].stringValue
                self.userModel.FirstName = responce["data"]["FirstName"].stringValue
                self.userModel.LastName = responce["data"]["LastName"].stringValue
                self.userModel.ProfilePicture = responce["data"]["ProfilePicture"].stringValue
                self.userModel.UserEmail =  responce["data"]["UserEmail"].stringValue
                self.userModel.RefCode = responce["data"]["RefCode"].stringValue
                self.userModel.ProfilePicture = responce["data"]["ProfilePicture"].stringValue
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
            print(self.firstName!)
            if self.firstName == ""{
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
//                vc.backBtn = "true"
//                vc.saveDetails = "true"
//                self.navigationController?.pushViewController(vc, animated:true)
                
                if self.userModel.ProfilePicture == ""{
                    self.imageView.downloadImage(url: "http://13.72.77.167:8088/ApplicationImages/defaultimage.png")
                }
                
                else{
                    self.imageView.downloadImage(url: self.userModel.ProfilePicture)
                }
                let param : [String:Any] = ["Id":"\(self.appDelegate.user_ID)","RoleId":"2","FirstName":self.usernameFirst,"LastName":self.usernameLast,"UserPassword":"","UserEmail":self.useremail ,"Skills":"","DeviceId":"","DeviceType":"iPhone","EmailType":"","Image":"","UserName":"","JobType":"","ReferalCode":self.userModel.RefCode]
                
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
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated:true)
        
    }
    
    
}


extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUserName {
            txtPssword.becomeFirstResponder()
        }
        else{
            txtPssword.resignFirstResponder()
        }
        
        return true
    }
}


extension LoginViewController :GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //if any error stop and print the error
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        self.username = user.profile.name ?? ""
        self.useremail = user.profile.email ?? ""
        self.usernameLast = user.profile.familyName ?? ""
        self.usernameFirst = user.profile.givenName ?? ""
//        self.AccessToekn = user.authentication.accessToken
        self.AccessToekn = user.userID!
        print(user.userID!)
       
        
        self.loginWithFBGoogle(Provider: "Google")
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
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
        
        if self.useremail == ""{
            
        }else{
            UserDefaults.standard.set(self.useremail, forKey: "UserEmailAppleId")
            UserDefaults.standard.synchronize()
        }
//        if useremail != ""{
//
//        }
//        else{
//            useremail = ""
//            username = ""
//        }
        let result = String("User ID:\(AccessToekn)\nEmail:\(self.useremail)\nName:\(username)")
        print(result)
        UserDefaults.standard.set(AccessToekn, forKey: "userIdentifier1")
        
        let DeviceId = UserDefaults.standard.value(forKey: "token") as! String
        let Provider = "Apple"
        emailId =  UserDefaults.standard.value(forKey: "UserEmailAppleId") as! String
        let apiController : APIController = APIController()
        print(useremail)
        print(username)
        print(AccessToekn)
        print(DeviceId)
        
        
        
        apiController.postRequest(methodName: "FacebookGoogleLogin?Email=\(emailId)&UserName=\(username)&TokenId=\(AccessToekn)&deviceId=\(DeviceId)&devicetype=iphone&Provider=\(Provider)") { (responce) in
            
            if responce["message"].stringValue == "success"{
                self.appDelegate.user_ID = responce["data"]["Id"].intValue
                self.firstName = responce["data"]["FirstName"].stringValue
                self.userModel.FirstName = responce["data"]["FirstName"].stringValue
                self.userModel.LastName = responce["data"]["LastName"].stringValue
                self.userModel.ProfilePicture = responce["data"]["ProfilePicture"].stringValue
                self.userModel.UserEmail =  responce["data"]["UserEmail"].stringValue
                self.userModel.RefCode = responce["data"]["RefCode"].stringValue
                self.userModel.ProfilePicture = responce["data"]["ProfilePicture"].stringValue
                UserDefaults.standard.set(self.appDelegate.user_ID, forKey: "login_Id")
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async {
                    self.loginAlert(msg: "Login_Successful".localized())
                    
                }
            }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

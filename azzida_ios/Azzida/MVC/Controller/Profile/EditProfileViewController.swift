//
//  EditProfileViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 28/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import Kingfisher

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var viewPasswordVw: UIView!
    @IBOutlet weak var viewHeightPasswordVw: NSLayoutConstraint!
    @IBOutlet weak var lblChangePhoto: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var lblSkills: UILabel!
    @IBOutlet weak var txtSkills: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var txtOldPassword: CustomTextField!
    @IBOutlet weak var txtNewPassword: CustomTextField!
    @IBOutlet weak var txtConfirmPassword: CustomTextField!
    
    var placeholderLabel : UILabel!
    var imagePicker: ImagePicker!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let userModel : UserModel = UserModel.userModel
    let constant : CommonStrings = CommonStrings.commonStrings
    lazy var CategoryArr : [String] = []
    var backBtn : String!
    var saveDetails : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        placeholderTextView()
        
        let editImag = UITapGestureRecognizer(target: self, action: #selector(self.editImag))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(editImag)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        txtEmail.text = userModel.UserEmail
        txtFirstName.text = userModel.FirstName
        txtLastName.text = userModel.LastName
        txtCategory.text = userModel.JobTypeCategory
        imgView.downloadImage(url: userModel.ProfilePicture)
        getJobCategory()
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
                
    }
    override func viewWillDisappear(_ animated: Bool) {
        backBtn = "false"
    }
    override func viewWillAppear(_ animated: Bool) {
        if userModel.provider == ""{
            viewHeightPasswordVw.constant = 279
            viewPasswordVw.isHidden = false
        }else{
            viewHeightPasswordVw.constant = 0
            viewPasswordVw.isHidden = true
        }
    }
    @objc func setText(){
        lblChangePhoto.text = "ChangePhoto".localized()
        btnSave.setTitle("Save".localized(), for: .normal)
        btnEdit.setTitle("Edit_Profile".localized(), for: .normal)
        lblFirstName.text = "FirstName".localized()
        lblLastName.text = "LastName".localized()
        lblEmail.text = "Email".localized()
        lblSkills.text = "Skills_Experience".localized()
        lblCategory.text = "Job_Categories".localized()
        
        txtFirstName.changePlaceHolder(text: "FirstName".localized())
        txtLastName.changePlaceHolder(text: "Last_Name".localized())
        txtEmail.changePlaceHolder(text: "Email".localized())
        txtCategory.changePlaceHolder(text: "Job_Categories".localized())
        
        txtCategory.delegate = self
        
    }
    
    @objc func editImag(sender:UITapGestureRecognizer) {
        self.imagePicker.present(from: imgView)
        
    }
    
    func getJobCategory(){
        let apiController : APIController = APIController()
        
        apiController.getRequest(methodName: "GetJobCategory", param: nil, isHUD: false) { (responce) in
            if responce["data"].arrayValue.count > 0{
                self.CategoryArr =  responce["data"].arrayValue.map { $0["CategoryName"].stringValue }
            }
        }
    }
    
    func placeholderTextView(){
        txtSkills.text = userModel.Skills
        
        txtSkills.delegate = self
        placeholderLabel = UILabel()
                placeholderLabel.text = "Mention your skills/experience"

//        placeholderLabel.text = "Mention your skills/experience \n(comma separated)"
        placeholderLabel.font = txtSkills.font
        placeholderLabel.sizeToFit()
        txtSkills.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtSkills.font?.pointSize)! / 2)
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textColor = UIColor.darkGray
        placeholderLabel.isHidden = !txtSkills.text.isEmpty
        
        txtEmail.delegate = self
        txtFirstName.delegate = self
        txtLastName.delegate = self
  
    }
    
    @IBAction func btnEditPhoto(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
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
        var password = userModel.UserPassword
        if(txtConfirmPassword.text! != "")
        {
            password = txtNewPassword.text!
        }
        
        let param : [String:Any] = ["Id":"\(appDel.user_ID)","RoleId":"2","FirstName":txtFirstName.text ?? "","LastName":txtLastName.text ?? "","UserPassword":password,"UserEmail":txtEmail.text ?? "","Skills":txtSkills.text ?? "","DeviceId":"\(DeviceId)","DeviceType":"iPhone","EmailType":"other","Image":"","UserName":userModel.UserName,"JobType":txtCategory.text ?? "","ReferalCode":userModel.RefCode]
        print(param)
        let apiController : APIController = APIController()
        apiController.EditProfile(params: param, image: imgView.image!) { (responce) in
            if responce["message"].stringValue == "success" {
                self.saveDetails = "false"
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
                DispatchQueue.main.async {
                    self.updateAlert(msg: "Profile Update Successfully!")
                }
            }
            
        }
    }
    
    func updateAlert(msg:String){
           let refreshAlert = UIAlertController(title: msg, message: "", preferredStyle: UIAlertController.Style.alert)
           refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
               DispatchQueue.main.async {
                if self.backBtn == "true"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated:true)
                }
                else{
                   self.navigationController?.popViewController(animated: true)
                }
               }
           }))
           present(refreshAlert, animated: true, completion: nil)
           
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
        if (txtOldPassword.text != "") || (txtNewPassword.text != "") || (txtConfirmPassword.text != "") {
            
                    if(txtOldPassword.text!.isEmpty)
                    {
                        Alert.alert(message:"Fill Old password", title: "Alert")
                        return false
                    }
            
            if(txtOldPassword.text != "" && txtOldPassword.text != userModel.UserPassword)
            {
                Alert.alert(message:"Old password does not match", title: "Alert")
                return false
            }
            if(txtNewPassword.text!.isEmpty)
            {
                Alert.alert(message:"Fill New password", title: "Alert")
                return false
            }
            if(txtConfirmPassword.text!.isEmpty)
                   {
                       Alert.alert(message:"Fill Confirm password", title: "Alert")
                       return false
                   }
            if(txtNewPassword.text != txtConfirmPassword.text)
                  {
                      Alert.alert(message:"Confirm password does not match", title: "Alert")
                      return false
                  }
                  
        }
       
        
//        if (txtCategory.text!.isEmpty){
//            Alert.alert(message:"Please_select_Job_Category".localized(), title: "Alert")
//            return false
//        }
        
        if !isValidEmail(txtEmail.text!){
            Alert.alert(message:"Please_enterValidEmail_address".localized(), title: "Alert")
            return false
            
        }
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        print(imgView.image!)
        if backBtn == "true"{
            print(imgView.image!)
            if (txtFirstName.text!.isEmpty) || (txtLastName.text!.isEmpty) {
                Alert.alert(message:"Add Profile Details", title: "Alert")
            }
            else if saveDetails == "true"{
                Alert.alert(message:"Please save details", title: "Alert")
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(vc, animated:true)
            }
        }
        else{
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func txtCategoryTap(_ sender: UITextField) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            
        }
        
    }

} 

extension EditProfileViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !txtSkills.text.isEmpty
    }
}

extension EditProfileViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        }
        else if textField == txtLastName {
            txtEmail.becomeFirstResponder()
        }
        else{
            
            txtSkills.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == txtCategory)
        {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.txtCategory.resignFirstResponder()
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryPickerViewController") as! CategoryPickerViewController
            vc.CategoryArr = self.CategoryArr
            vc.categoryStr = self.txtCategory.text!
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension EditProfileViewController: ImagePickerDelegate {

    func didDelete() {
        
    }
    
    func didSelect(image: UIImage?) {
        if image != nil{
            backBtn = "true"
        self.imgView.image = image
        }
    }
}

extension EditProfileViewController : SelectCategoryDelegate{
    func GetCategory(category: String) {
        txtCategory.text = category
    }
    
}

extension UIImageView {
    
    func downloadImage(url:String) {
        let url = URL(string:url)
        //  imgView.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "no_profile"), options: nil, progressBlock: nil) { result in
            let image = try? result.get().image
            if let image = image {
                self.self.image = image
            }
            else{
                self.self.image = #imageLiteral(resourceName: "no_profile")
            }
        }
    }
    
}


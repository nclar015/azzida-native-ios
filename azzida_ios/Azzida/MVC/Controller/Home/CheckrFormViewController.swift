//
//  CheckrFormViewController.swift
//  Azzida
//
//  Created by iVishnu on 04/09/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import WebKit

class CheckrFormViewController: UIViewController,WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var BGView : UIView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var txtFirstName : UITextField!
    @IBOutlet weak var txtMiddleName : UITextField!
    @IBOutlet weak var txtLastName : UITextField!
    @IBOutlet weak var txtDOB : UITextField!
    @IBOutlet weak var txtSocialSecurity : UITextField!
    @IBOutlet weak var txtZipCode : UITextField!
    @IBOutlet weak var txtPhoneNo : UITextField!
    @IBOutlet weak var txtEmailAddress : UITextField!
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnCheckbox: UIButton!
    
    @IBOutlet weak var webview: WKWebView!
   
    var datePickerView:UIDatePicker = UIDatePicker()
    lazy var activeTextField = UITextField()
    let disclosureFile = "Disclosure"
    let authorizationFile = "Authorization"
    let californiaDisclosureFile = "CaliforniaDisclosure"
    let rightsFile = "Rights"
    var selectedIndex = 0
    var isAccepted = false
    let userModel : UserModel = UserModel.userModel
   
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDelegates()
        btnOne.layer.cornerRadius = btnOne.frame.size.height/2
        btnTwo.layer.cornerRadius = btnOne.frame.size.height/2
        btnPrevious.layer.borderColor = UIColor.black.cgColor
        btnPrevious.layer.borderWidth = 1
        btnThree.layer.cornerRadius = btnOne.frame.size.height/2
        btnFour.layer.cornerRadius = btnOne.frame.size.height/2
        btnFive.layer.cornerRadius = btnOne.frame.size.height/2
        datePickerView.set16YearValidation()
        txtSocialSecurity.maxLength = 11
        self.webview.navigationDelegate = self
        if let filePath = Bundle.main.url(forResource: disclosureFile, withExtension: "html") {
            let request = NSURLRequest(url: filePath)
            webview.load(request as URLRequest)

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
    
    func textFieldDelegates(){
        txtFirstName.changePlaceHolder(text: "First name")
        txtLastName.changePlaceHolder(text: "Last name")
        txtMiddleName.changePlaceHolder(text: "Middle name")
        txtEmailAddress.changePlaceHolder(text: "Email address")
        txtDOB.changePlaceHolder(text: "Date of Birth")
        txtSocialSecurity.changePlaceHolder(text: "Social Security Number")
        txtZipCode.changePlaceHolder(text: "Current zip code")
        txtPhoneNo.changePlaceHolder(text: "Phone number")
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtMiddleName.delegate = self
        txtDOB.delegate = self
        txtSocialSecurity.delegate = self
        txtZipCode.delegate = self
        txtPhoneNo.delegate = self
        txtEmailAddress.delegate = self
        
//        lblTitle.isHidden = true
        
        txtEmailAddress.keyboardType = .emailAddress
        txtPhoneNo.keyboardType = .phonePad
        txtSocialSecurity.keyboardType = .phonePad
        txtZipCode.keyboardType = .numberPad
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
           if navigationAction.navigationType == .linkActivated  {
               if let url = navigationAction.request.url,
                  let host = url.host,
                  UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url)
                   print(url)
                   print("Redirected to browser. No need to open it locally")
                   decisionHandler(.cancel)
               } else {
                   print("Open it locally")
                   decisionHandler(.allow)
               }
           } else {
               print("not a user click")
               decisionHandler(.allow)
           }
       }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {

        if !isValid(){
            return
        }
        let dict : [String:Any] = ["first_name":txtFirstName.text ?? "",
        "middle_name":txtMiddleName.text ?? "",
        "last_name":txtLastName.text ?? "",
        "email":txtEmailAddress.text ?? "",
        "phone":txtPhoneNo.text ?? "",
        "zipcode":txtZipCode.text ?? "",
        "dob":txtDOB.text ?? "",
        "ssn":txtSocialSecurity.text ?? "",
        "no_middle_name": txtMiddleName.text == "" ? true:false]
        
//        let dict : [String:Any] = ["first_name":"Michael",
//            "middle_name":"Gary",
//            "last_name":"Scott",
//            "email":txtEmailAddress.text ?? "",
//            "phone":"203540892",
//            "zipcode":"06831",
//            "dob":"1964-03-15",
//            "ssn":"111-11-2001"]
//
//        print("params",dict)
        print(txtEmailAddress.text!)
        let apiController: APIController = APIController()
        apiController.postRequestForChecker(methodName: "https://api.checkr.com/v1/candidates", params: dict) { (respone) in
            if respone["error"].stringValue == "" {
                print("SUCESS_SUCESS")
                //TODO: API Call
                self.userModel.candidateId = respone["id"].stringValue
                print(self.userModel.candidateId)
                let params : [String:Any] = [
                    "UserId":AppDelegate.sharedDelegate().user_ID,
                    "CandidateId":respone["id"].stringValue,
                    "CFirstName":respone["first_name"].stringValue,
                    "CLastName":respone["last_name"].stringValue,
                    "CMiddleName":respone["middle_name"].stringValue,
                    "CDOB":respone["dob"].stringValue,
                    "Cssn":respone["ssn"].stringValue,
                    "CEmail":respone["email"].stringValue,
                    "CPhone":respone["phone"].stringValue,
                    "CZipCode":respone["zipcode"].stringValue,
                    "CCreatedAt":respone["created_at"].stringValue,
                    "IpAddress":UIDevice.current.ipAddress()!
                ]
                APIController().updateCandidateData(params: params) { (response) in
                     if respone["error"].stringValue == "" {
                        
                         let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionWebViewController") as! OptionWebViewController
                                        vc.successChecker = "yes"
                        self.userModel.azzidaVerified = true
                                              self.navigationController?.pushViewController(vc, animated: true)

//                    DispatchQueue.main.async {
//                        self.navigationController?.popToViewController(ofClass: HomeViewController.self, animated: true)
                    }
                }
            }
            else
            
            {
                Alert.alert(message: "", title: "invalid user credentials")
            }
            
        }
    }
    
    func isValid() -> Bool{
        if (txtFirstName.text!.isEmpty){
            Alert.alert(message:"Please enter First Name".localized(), title: "Alert")
            return false
        }
        
//        if (txtMiddleName.text!.isEmpty){
//            Alert.alert(message:"Please enter middle name.", title: "Alert")
//            return false
//        }
        if (txtLastName.text!.isEmpty){
            Alert.alert(message:"Please enter last Name".localized(), title: "Alert")
            return false
        }
        if (txtEmailAddress.text!.isEmpty){
            Alert.alert(message:"Please enter Email".localized(), title: "Alert")
            return false
        }
        
        if !isValidEmail(txtEmailAddress.text!){
            Alert.alert(message:"Please enter Valid Email address".localized(), title: "Alert")
            return false
            
        }
        if (txtDOB.text!.isEmpty){
            Alert.alert(message:"Please select DOB.", title: "Alert")
            return false
        }
        
        if (txtSocialSecurity.text!.isEmpty){
            Alert.alert(message:"Please enter Social Security number.", title: "Alert")
            return false
        }
        
        if (txtZipCode.text!.isEmpty){
            Alert.alert(message:"Please enter ZipCode.", title: "Alert")
            return false
        }
        
        if (txtPhoneNo.text!.isEmpty){
            Alert.alert(message:"Please enter phone number.", title: "Alert")
            return false
        }
        
        
        
        return true
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[a-zA-Z0-9._-]+@[a-z]+(\\.[a-z]+)*(\\.[a-z]{2,})$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    @IBAction func checkboxAction(_ sender: Any) {
        isAccepted = !isAccepted
        if(isAccepted)
        {
            btnCheckbox.setImage(UIImage(named: "Filter_checked"), for: .normal)
            btnContinue.backgroundColor = UIColor(red: 0.43, green: 0.69, blue: 0.86, alpha: 1.00)
        }
        else
        {
            btnCheckbox.setImage(UIImage(named: "Filter_unchecked"), for: .normal)
            btnContinue.backgroundColor = UIColor.lightGray
        }
        btnContinue.isEnabled = isAccepted
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if btnContinue.isEnabled == isAccepted{
            print("ok")
       if(selectedIndex == 0)
        {
            btnPrevious.isHidden = false
        }
        var pageToLoad = ""
        if(selectedIndex == 3)
        {
            webview.isHidden = true
            bottomView.isHidden = true
            btnFour.setImage(UIImage(named: "Correct"), for: .normal)
            btnFour.setTitle("", for: .normal)
        }
        else if(selectedIndex == 2)
        {
            pageToLoad = authorizationFile
            btnThree.setImage(UIImage(named: "Correct"), for: .normal)
            btnThree.setTitle("", for: .normal)
        }
        else if(selectedIndex == 1)
        {
            pageToLoad = californiaDisclosureFile
            btnTwo.setImage(UIImage(named: "Correct"), for: .normal)
            btnTwo.setTitle("", for: .normal)
        }
        else if(selectedIndex == 0)
        {
            pageToLoad = rightsFile
            btnOne.setImage(UIImage(named: "Correct"), for: .normal)
            btnOne.setTitle("", for: .normal)
        }
        if let filePath = Bundle.main.url(forResource: pageToLoad, withExtension: "html") {
            let request = NSURLRequest(url: filePath)
            webview.load(request as URLRequest)
        }
        selectedIndex += 1
    }
        else{
           print("done")
        }
}
    
    @IBAction func previousAction(_ sender: UIButton) {
        if(selectedIndex == 1)
        {
            sender.isHidden = true
        }
        var pageToLoad = ""
        if(selectedIndex == 4)
        {
            pageToLoad = authorizationFile
            btnFive.setImage(nil, for: .normal)
            btnFive.setTitle("5", for: .normal)
        }
        else if(selectedIndex == 3)
        {
            pageToLoad = californiaDisclosureFile
            btnFour.setImage(nil, for: .normal)
            btnFour.setTitle("4", for: .normal)
        }
        else if(selectedIndex == 2)
        {
            pageToLoad = rightsFile
            btnThree.setImage(nil, for: .normal)
            btnThree.setTitle("3", for: .normal)
        }
        else if(selectedIndex == 1)
        {
            pageToLoad = disclosureFile
            btnTwo.setImage(nil, for: .normal)
            btnTwo.setTitle("2", for: .normal)
        }
        else if(selectedIndex == 1)
        {
            pageToLoad = rightsFile
            btnOne.setImage(nil, for: .normal)
            btnOne.setTitle("1", for: .normal)
        }
        if let filePath = Bundle.main.url(forResource: pageToLoad, withExtension: "html") {
            let request = NSURLRequest(url: filePath)
            webview.load(request as URLRequest)
        }
        selectedIndex -= 1
    }
    
}


extension CheckrFormViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if textField == txtDOB{
            self.pickUpDate(textField)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(txtSocialSecurity == textField)
        {
            
            var originalText = textField.text
            
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                }else{
                    if range.location == 3 || range.location == 6 {
                        originalText?.append("-")
                        
                        txtSocialSecurity.text = originalText
                    }
                }
            }
            return true
        }
        else
        {
            return true
        }
    }
    
    
    func pickUpDate(_ textField : UITextField){
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
//            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePickerView.minuteInterval = 15
        // datePickerView = datePickerView
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddJobViewController.doneTapped))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        self.txtDOB.inputView = datePickerView
        self.txtDOB.inputAccessoryView = toolBar
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func doneTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM-dd-YYYY"
        self.txtDOB.text = dateFormatter.string(from: datePickerView.date)
        self.txtDOB.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM-dd-YYYY"
        self.txtDOB.text = dateFormatter.string(from: sender.date)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if activeTextField == txtFirstName{
            txtMiddleName.becomeFirstResponder()
        }
        else if activeTextField == txtMiddleName{
            txtLastName.becomeFirstResponder()
        }
        else if activeTextField == txtLastName{
            txtEmailAddress.becomeFirstResponder()
        }
        else if activeTextField == txtEmailAddress{
            txtDOB.becomeFirstResponder()
        }
        else if activeTextField == txtDOB{
            txtSocialSecurity.becomeFirstResponder()
        }
        else if activeTextField == txtSocialSecurity{
            txtZipCode.becomeFirstResponder()
        }
        else if activeTextField == txtZipCode{
            txtPhoneNo.becomeFirstResponder()
        }
        else {
            txtPhoneNo.becomeFirstResponder()
        }
        
        return true
    }
    
}


extension UIDatePicker {
    func set16YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    } }

//
//  AddPaymentViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 28/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import Stripe

class AddPaymentViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var lblAddPayment: UILabel!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblCVV: UILabel!
    @IBOutlet weak var lblExpiry: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtExpiry: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var toolbar: UIToolbar!
    let expiryDatePicker = MonthYearPickerView()
    var PaymentType = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var expMonth = ""
    var expYear = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        txtCVV.keyboardType = .numberPad
        txtExpiry.keyboardType = .numberPad
        txtNumber.keyboardType = .numberPad
        
        txtNumber.delegate = self
        txtNumber.maxLength = 20
        txtCVV.delegate = self
        txtCVV.maxLength = 3
        //        txtExpiry.delegate = self
        //        txtExpiry.maxLength = 5
        
        txtExpiry.inputView = expiryDatePicker
        txtExpiry.inputAccessoryView = toolbar
        if PaymentType == "MakePayment" {
            self.btnSave.setTitle("Make Payment", for: .normal)
        }
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year%100)
            print(string) // should show something like 05/2015
            self.txtExpiry.text = string
        }
        
        //-----------------------------------------Updated Code------------------------------
        
        if traitCollection.userInterfaceStyle == .dark{
            lblCardName.textColor = UIColor.white
            lblCardNumber.textColor = UIColor.white
            lblCVV.textColor = UIColor.white
            lblExpiry.textColor = UIColor.white
            //            txtCVV.textColor = UIColor.black
            //            txtName.textColor = UIColor.black
            //            txtExpiry.textColor = UIColor.black
            //            txtNumber.textColor = UIColor.black
            self.view.backgroundColor = .black
            txtName.backgroundColor = .black
            txtName.layer.borderColor = UIColor.white.cgColor
            
        }else{
            
            lblCardName.textColor = UIColor.black
            lblCardNumber.textColor = UIColor.black
            lblCVV.textColor = UIColor.black
            lblExpiry.textColor = UIColor.black
            
        }
        
        
        
        
        
    }
    
    @objc func setText(){
        lblAddPayment.text = "Add_New_Payment_Method".localized()
        lblCardName.text = "Name_on_the_Card".localized()
        lblCardNumber.text = "Card_Number".localized()
        lblExpiry.text = "Expiry".localized()
        lblCVV.text = "CVV".localized()
        self.btnSave.setTitle("Save_Card".localized(), for: .normal)
        
        txtName.changePlaceHolder(text: "Enter Full Name")
        txtCVV.changePlaceHolder(text: "CVV")
        txtNumber.changePlaceHolder(text: "0000 0000 0000 0000")
        txtExpiry.changePlaceHolder(text: "MM/YY")
        
    }
    
    @IBAction func btnSaveCard(_ sender: UIButton) {
        let v = CreditCardValidator()
        if let type = v.type(from: txtNumber.text!){
            if(type.name == "Amex"){
                if (txtCVV.text!.count < 4) {
                    Alert.alert(message: "", title: "Invalid CVV")
                }
                else{
                    saveCard()
                }
            }
            else{
               saveCard()
            }
        }
    }
    
    func saveCard(){
        if !Valid(){
            return
        }
        
        expMonth = StripCheck.getValidExpiry(text: txtExpiry.text!).0
        expYear = StripCheck.getValidExpiry(text: txtExpiry.text!).1
        
        
        let cardParams = STPCardParams()
        cardParams.number = txtNumber.text!
        cardParams.expMonth = UInt(expMonth) ?? 0
        cardParams.expYear = UInt(expYear) ?? 0
        cardParams.cvc = txtCVV.text!
        cardParams.name = txtName.text!
        
        
        if !StripCheck.isCardDetailValid(cardNumber: txtNumber.text!.replacingOccurrences(of: " ", with: ""), month: UInt(expMonth) ?? 0, year: UInt(expYear) ?? 0, cvv: txtCVV.text!){
            Alert.alert(message: "", title: "Card Detail is invalid")
            
            return
        }
        
        STPAPIClient.shared.createToken(withCard: cardParams) { (token, error) in
            print(cardParams)
            if error != nil {
                print("intregation failed")
                Alert.alert(message: "", title: "Card number is invalid")
                // show the error to the user
            }
                
            else if let token = token {
                print(token)
                print(token.stripeID)
                DispatchQueue.main.async {
                    self.SaveCardAPI(tokenid: token.stripeID)
                }
                
            }
        }
    }
    
    
    
    
    // SaveCard(string tokenid, int userid)
    
    
    func SaveCardAPI(tokenid:String){
        let apiController : APIController = APIController()
//        let testValue = "live"
//        let testValue = "test"
        apiController.postRequest(methodName: "SaveCard?tokenid=\(tokenid)&userid=\(self.appDelegate.user_ID)&TokenUsed=\(AppTokenUsed.tokenUsed)") { (responce) in
            if responce["message"].stringValue == "success"{
                DispatchQueue.main.async {
                    self.CardAddAlert(msg: "Card Add Successful.")
                }
            }
        }
    }
    
    func CardAddAlert(msg:String){
        let alert = UIAlertController(title: msg, message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Add_Card"), object: nil, userInfo: ["status":true])
            
        }
    }
    
    func Valid()->Bool{
        if (txtName.text?.isEmpty)!{
            Alert.alert(message: "", title: "Please_enter_card_holder_name".localized())
            return false
        }
        if (txtNumber.text?.isEmpty)!{
            Alert.alert(message: "", title: "Please_enter_card_number".localized())
            return false
        }
        if (txtExpiry.text?.isEmpty)! || txtExpiry.text!.count < 5{
            Alert.alert(message: "", title: "Please_enter_card_expiry".localized())
            return false
        }
        if (txtCVV.text?.isEmpty)!{
            Alert.alert(message: "", title: "Please_enter_card_CVV".localized())
            return false
        }
        
        return true
    }
    
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.txtExpiry.resignFirstResponder()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.txtExpiry.resignFirstResponder()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        if textField == txtNumber {
            
            var originalText = textField.text
            
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                }else{
                    let rangeIndex = range.location
                    
                    if rangeIndex % 5 == 0 {
                        originalText?.append(" ")
                        txtNumber.text = originalText
                    }
                }
            }
            let v = CreditCardValidator()
            if let type = v.type(from: txtNumber.text!){
                // Visa, Mastercard, Amex etc.
                print(type.name)
                if(type.name == "Amex")
                {
                    txtCVV.maxLength = 4
                }
                else
                {
                    txtCVV.maxLength = 3
                }
            } else {
                // I Can't detect type of credit card
            }
            return true
            
            
        }
        else if textField == txtExpiry {
            
            var originalText = textField.text
            
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                }else{
                    if range.location == 2 {
                        originalText?.append("/")
                        
                        txtExpiry.text = originalText
                    }
                }
            }
            return true
            
            
        }
        else {
            return true
        }
    }
    
}



class StripCheck{
    class func isCardDetailValid(cardNumber : String, month : UInt, year : UInt, cvv : String) -> Bool {
        let params = STPCardParams()
        params.number = cardNumber
        params.expMonth = month
        params.expYear = year
        params.cvc = cvv
        if STPCardValidator.validationState(forCard: params) == .valid {
            return true
        } else {
            return false
        }
    }
    
    class func getValidExpiry(text:String)->(String,String){
        let expiryString = text.components(separatedBy: "/")
        let month = "\(expiryString[0])"
        let year = "\(expiryString[1])"
        return(month,year)
    }
}

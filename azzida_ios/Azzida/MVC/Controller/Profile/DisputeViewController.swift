//
//  DisputeViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 28/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class DisputeViewController: UIViewController {
    
    @IBOutlet weak var btnBackToProfile: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblWeWant: UILabel!
    @IBOutlet weak var lblReson: UILabel!
    @IBOutlet weak var txtReson: UITextField!
    @IBOutlet weak var lblAssociates: UILabel!
    @IBOutlet weak var txtAssociates: UITextField!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var lblDescribe: UILabel!
    @IBOutlet weak var txtDescribe: UITextView!
    @IBOutlet weak var lblAddAttechment: UILabel!
    @IBOutlet weak var imgAttech: UIImageView!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var btnAcceptTerms: UIButton!
    @IBOutlet weak var lblAddPhotoAndDocuments: UILabel!
    
    
    var placeholderLabel : UILabel!
    lazy var activeTextField = UITextField()
    var imagePicker: ImagePicker!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pickerView : UIPickerView!
    var PickArr = ["One","Two","Three"]
    let constant : CommonStrings = CommonStrings.commonStrings
    var PostAssociateArr : [String] = []
    var dispatchIndex = 0
    var data : [JSON] = []
    let userModel : UserModel = UserModel.userModel
    var amount = ""
    var JobID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        placeholderTextView()
        setTermsString()
        GetPostAssociate()
    }
    
    @objc func setText(){
        lblWeWant.text = "We_Want_to_Help".localized()
        btnBackToProfile.setTitle("Back_To_Profile".localized(), for: .normal)
        btnSubmit.setTitle("Submit".localized(), for: .normal)
        lblReson.text = "Reason_for_dispute".localized()
        lblAssociates.text = "Post_associated".localized()
        //  lblContact.text = "Best_way_to_contact".localized()
        lblDescribe.text = "Describe_what_happened".localized()
        lblAddAttechment.text = "AddAttachment".localized()
        
        //  txtReson.changePlaceHolder(text: "Enter_title_here".localized())
        txtAssociates.changePlaceHolder(text: "Select")
        //  txtContact.changePlaceHolder(text: "Select")
        txtReson.changePlaceHolder(text: "Enter Reason for dispute")
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func placeholderTextView(){
        txtDescribe.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Please explain the issue..."
        placeholderLabel.font = txtDescribe.font
        placeholderLabel.sizeToFit()
        txtDescribe.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtDescribe.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.darkGray
        placeholderLabel.isHidden = !txtDescribe.text.isEmpty
        
        txtReson.delegate = self
        txtAssociates.delegate = self
        txtContact.delegate = self
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        if !valid(){
            return
        }
        
        
        if self.data[dispatchIndex]["Amount"].intValue < 100{
            amount = "5"
        }else{
            amount = calculatePercentage(value:self.data[dispatchIndex]["Amount"].doubleValue , percentageVal: 5.0)
        }
        
        print("amount",amount)
        JobID = self.data[dispatchIndex]["Id"].intValue
        
        
        
        userModel.DisputeReason = txtReson.text ?? ""
        userModel.DisputePostAssociate = txtAssociates.text ?? ""
        userModel.DisputeDescription = txtDescribe.text ?? ""
       
        if imgAttech.image != nil{
        userModel.DisputeImage = imgAttech.image!
            print(userModel.DisputeImage)
        }
       
        
        let vc = SecondStoryboard.instantiateViewController(withIdentifier: "SelectPaymentViewController") as! SelectPaymentViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.PaymentType = "Dispute"
        vc.amount = amount
        vc.jobId = self.data[dispatchIndex]["Id"].intValue
        vc.delegate = self
        vc.promoCodeHide = "true"
        vc.paymentValue = "true"
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func GetPostAssociate(){
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "UserId":appDelegate.user_ID
        ]
        apiController.getRequest(methodName: "PostAssociate", param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success"{
                DispatchQueue.main.async {
                    self.data = responce["data"].arrayValue
                    self.PostAssociateArr =  responce["data"].arrayValue.map { $0["postassociate"].stringValue }
                }
            }
        }
    }
    
    func calculatePercentage(value:Double,percentageVal:Double)->String{
        var val = value * percentageVal
        val = val / 100.0
        var vals : String = String(val.rounded())
        vals = vals.replacingOccurrences(of: ".0", with: "")
        return vals
    }
    
    @IBAction func btnAddAttechment(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func btnAcceptTerms(_ sender: UIButton) {
        if (sender.isSelected == true)
        {
            sender.setBackgroundImage(UIImage(named: "Filter_unchecked"), for: .normal)
            sender.isSelected = false;
        }
        else
        {
            sender.setBackgroundImage(UIImage(named: "Filter_checked"), for: .normal)
            sender.isSelected = true;
        }
        
    }
    
    
    
    func valid() -> Bool{
        if (txtReson.text!.isEmpty){
            Alert.alert(message: "Enter_Reason_for_dispute".localized(), title: "Alert")
            return false
        }
        if (txtAssociates.text!.isEmpty){
            Alert.alert(message: "select_Post_associated".localized(), title: "Alert")
            
            return false
        }
        //        if (txtContact.text!.isEmpty){
        //            Alert.alert(message: "select_Best_way_to_contact".localized(), title: "Alert")
        //
        //            return false
        //        }
        if (txtDescribe.text!.isEmpty){
            Alert.alert(message: "Please_explain_the_issue_Alert".localized(), title: "Alert")
            
            return false
        }
        
//        if (imgAttech.image == nil){
//            Alert.alert(message: "Please_Add_Attachment".localized(), title: "Alert")
//            return false
//        }
        
        if !btnAcceptTerms.isSelected{
            Alert.alert(message: "Please Accept Dispute Resolution Policy.", title: "Alert")
            return false
        }
        
        return true
    }
    
    func setTermsString(){
        
        
        if self.traitCollection.userInterfaceStyle == .dark{
            let agree = NSAttributedString(string:"I have read and agree to the Azzida ",
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.white,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 16) as Any])
            
            let Policy = NSAttributedString(string:"Dispute Resolution Policy.",
                                            attributes:[NSAttributedString.Key.foregroundColor: constant.theamBlueColor,
                                                        NSAttributedString.Key.font: UIFont(name: "Arial", size: 16) as Any,
                                                        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
            
            let combination = NSMutableAttributedString()
            combination.append(agree)
            combination.append(Policy)
            
            lblTerms.attributedText = combination
            lblTerms.isUserInteractionEnabled = true
            lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
            
        }else{
            
            
            
            let agree = NSAttributedString(string:"I have read and agree to the Azzida ",
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 16) as Any])
            
            let Policy = NSAttributedString(string:"Dispute Resolution Policy.",
                                            attributes:[NSAttributedString.Key.foregroundColor: constant.theamBlueColor,
                                                        NSAttributedString.Key.font: UIFont(name: "Arial", size: 16) as Any,
                                                        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
            
            let combination = NSMutableAttributedString()
            combination.append(agree)
            combination.append(Policy)
            
            lblTerms.attributedText = combination
            lblTerms.isUserInteractionEnabled = true
            lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
//        let agree = NSAttributedString(string:"I have read and agree to the Azzida ",
//                                       attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
//                                                   NSAttributedString.Key.font: UIFont(name: "Arial", size: 16) as Any])
//
//        let Policy = NSAttributedString(string:"Dispute Resolution Policy.",
//                                        attributes:[NSAttributedString.Key.foregroundColor: constant.theamBlueColor,
//                                                    NSAttributedString.Key.font: UIFont(name: "Arial", size: 16) as Any,
//                                                    NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
//
//        let combination = NSMutableAttributedString()
//        combination.append(agree)
//        combination.append(Policy)
//
//        lblTerms.attributedText = combination
//        lblTerms.isUserInteractionEnabled = true
//        lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        guard let text = self.lblTerms.text else { return }
        let privacyPolicyRange = (text as NSString).range(of: "Dispute Resolution Policy.")
        if gesture.didTapAttributedTextInLabel(label: self.lblTerms, inRange: privacyPolicyRange) {
            guard let url = URL(string: "https://azzida.com/odd_jobs/azzida-terms-of-use/#Disputes") else { return }
            UIApplication.shared.open(url)
            
        }
    }
}

extension DisputeViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !txtDescribe.text.isEmpty
    }
}



extension DisputeViewController : UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if activeTextField == txtAssociates{
            self.pickUp(activeTextField)
        }
        //        if activeTextField == txtContact{
        //            self.pickUp(activeTextField)
        //        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if activeTextField == txtReson{
            txtAssociates.becomeFirstResponder()
        }
            //        else if activeTextField == txtAssociates{
            //            txtContact.becomeFirstResponder()
            //        }
        else {
            txtDescribe.becomeFirstResponder()
        }
        return true
    }
    
    
    func pickUp(_ textField : UITextField){
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
//        self.pickerView.backgroundColor = UIColor.white
        activeTextField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //    toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
//        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        activeTextField.inputAccessoryView = toolBar
        
    }
    
    
    @objc func doneClick() {
        if(PostAssociateArr.count > 0)
        {
            if activeTextField == txtAssociates{
                let indexPath = pickerView.selectedRow(inComponent: 0)
                activeTextField.text = PostAssociateArr[dispatchIndex]
            }
        }
        activeTextField.resignFirstResponder()
        //        if activeTextField == txtContact{
        //            let indexPath = pickerView.selectedRow(inComponent: 0)
        //            activeTextField.text = PickArr[indexPath]
        //            activeTextField.resignFirstResponder()
        //        }
    }
    
    @objc func cancelClick() {
        activeTextField.resignFirstResponder()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == txtAssociates{
            return PostAssociateArr.count
        }
        return PickArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTextField == txtAssociates{
            return  PostAssociateArr[row]
        }
        return  PickArr[row]
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeTextField == txtAssociates{
            //  activeTextField.text = PostAssociateArr[row]
            dispatchIndex = row
        }else{
            activeTextField.text = PickArr[row]
        }
    }
    
    
}

extension DisputeViewController: ImagePickerDelegate {
    
    func didDelete() {
        
    }
    
    func didSelect(image: UIImage?) {
        if image != nil{
            self.lblAddPhotoAndDocuments.isHidden = true
            self.imgAttech.image = image
        }
    }
}


extension DisputeViewController : JobRepostDelegate{
    func dismisViewController() {
        let vc = Mainstoryboard.instantiateViewController(withIdentifier: "EditPaymentViewController") as! EditPaymentViewController
        vc.PaymentMode = "MakePayment"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}


extension DisputeViewController : SucessPaymentDelegate{
    
    func backPopup(PaymentType: String, PaymentMethod: String, selectedPromoJson: JSON, selectedCode: String) {
        if PaymentType == "NewCard" {
            let vc = SecondStoryboard.instantiateViewController(withIdentifier: "PayWithNewCardViewController") as! PayWithNewCardViewController
            vc.PaymentType = "Dispute"
            vc.amount = amount
            vc.jobId = JobID
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{

            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.popToViewController(ofClass: HomeViewController.self)
            
        }
    }
    
}


//
//  AddJobViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 01/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces


class AddJobViewController: UIViewController,CLLocationManagerDelegate, CalendarViewDelegate, MBProgressHUDDelegate{
    
    
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var collectionWidth: NSLayoutConstraint!
    @IBOutlet weak var imgCollection: UICollectionView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddPhote: UILabel!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var txtCall: UITextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var txtHours: UITextField!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lblCategori: UILabel!
    @IBOutlet weak var txtCategori: UITextField!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var txtDetails: UITextView!
    @IBOutlet weak var btnCamera: UIButton!
    
    //    var placeholderLabel : UILabel!
    lazy var CategoryArr : [String] = []
    var pickerView : UIPickerView!
    lazy var activeTextField = UITextField()
    lazy var cateIndex = 0
    lazy var HowlongIndex = 0
    
    var imagePicker: ImagePicker!
    var datePickerView:UIDatePicker = UIDatePicker()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dateInMillis : Double!
    var currantlat: CLLocationDegrees!
    var currantlong:CLLocationDegrees!
    var selectPlaceLate: CLLocationDegrees!
    var selectPlaceLong:CLLocationDegrees!
    var JobID = 0
    var isEdit = false
    var FeedJob = JSON()
    var selectImageArr : [UIImage] = []
    let syncInto = SyncBlock()
    var uploadImgUrl : [String] = []
    var apiImageArr : [String] = []
    var EditIndex = 0
    var imagGroup = DispatchGroup()
    var HUD:MBProgressHUD!
    var dateValue : String!
    var HourCountArr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    var HourTypeArr = ["Hour(s)","Day(s)","Month(s)"]
    var HowlongArr = ["Less than an hour","1-2 hours","Half a day","Whole day","Up to a week","Up to a month","Not sure"]
    let GMSAutocompleteVC = GMSAutocompleteViewController()
    let userModel : UserModel = UserModel.userModel
    var dateValueFormate : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addHUD()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        placeholderTextView()
        getJobCategory()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        // getcurrentLatlong()
        
        if isEdit {
            btnPost.setTitle("Save", for: .normal)
            setData()
        }else{
            btnPost.setTitle("Post", for: .normal)
            collectionWidth.constant = 80
            //                  selectImageArr.append(UIImage(named: "AddPhoto-Plus")!)
        }
        
        imgCollection.register(UINib(nibName: "AddImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddImageCollectionViewCell")
        
        
        
        placeholderView.layer.cornerRadius = 20
        //        viewBackgroundImgVw.layer.borderWidth = 1.0
        placeholderView.layer.shadowColor = UIColor.black.cgColor
        placeholderView.layer.shadowOffset = CGSize(width: 2.0 , height: 4.0 )
        placeholderView.layer.shadowOpacity = 0.3
        placeholderView.layer.shadowRadius = 2.0
        placeholderView.layer.masksToBounds = false
        // todays date.
        let date = Date()
        print(date)
        // create an instance of calendar view with
        // base date (Calendar shows 12 months range from current base date)
        // selected date (marked dated in the calendar)
        let calendarView = CalendarView.instance(baseDate: date, selectedDate: date)
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(calendarView)
        
        // Constraints for calendar view - Fill the parent view.
        placeholderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[calendarView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        placeholderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[calendarView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        //        for index in 0..<FeedJob["imageList"].arrayValue.count{
        //                   let json = FeedJob["imageList"].arrayValue[index]
        //                   self.downloadImage(url: FeedJob["imageList"][index]["ImageName"].stringValue, index: index)
        //                   self.syncInto.wait()
        //               }
    }
    
    func addHUD(){
        HUD = MBProgressHUD(view:self.view)
        HUD.color = UIColor(displayP3Red: 47/255, green: 97/255, blue: 173/255, alpha: 1.0)
        //  HUD.mode = .indeterminate
        HUD.delegate = self
        HUD.labelText = "fetching Please wait..."
        self.view.addSubview(HUD!)
    }
    func showHud(){
        DispatchQueue.main.async {
            self.HUD.show(true)
        }
    }
    func hideHud(){
        DispatchQueue.main.async {
            self.HUD.hide(true)
        }
    }
    
    
    func placeholderTextView(){
        //        txtDetails.text = FeedJob["JobDescription"].stringValue
        
        txtDetails.delegate = self
        //        placeholderLabel = UILabel()
        //        placeholderLabel.text = ""
        //        placeholderLabel.font = txtDetails.font
        //        placeholderLabel.sizeToFit()
        //        txtDetails.addSubview(placeholderLabel)
        //        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtDetails.font?.pointSize)! / 2)
        //        placeholderLabel.textColor = UIColor.lightGray
        //        placeholderLabel.isHidden = !txtDetails.text.isEmpty
        
        txtCategori.delegate = self
        txtCall.delegate = self
        txtDate.delegate = self
        txtHours.delegate = self
        txtAmount.delegate = self
        txtLocation.delegate = self
        
        txtAmount.keyboardType = .numberPad
        
        
        txtCall.changePlaceHolder(text: "Enter_title_here".localized())
        //        txtDate.changePlaceHolder(text: "Select_date".localized())
        txtHours.changePlaceHolder(text: "Select")
        txtAmount.changePlaceHolder(text:  "$ " + "Enter_amount".localized())
        txtCategori.changePlaceHolder(text: "Select_Category".localized())
        txtLocation.changePlaceHolder(text: "Enter_the_locaiton".localized())
        
    }
    
    @objc func setText(){
        btnTitle.setTitle("Back_to_Feed".localized(), for: .normal)
        lblTitle.text = "Lets_Get_Something_Done".localized()
        lblAddPhote.text = "Add_Photo".localized()
        lblCall.text = "What_would_you_call_it".localized()
        lblDate.text = "When_do_you_need_it".localized()
        lblAmount.text =  "How_much_do_you_want_to_pay".localized()
        lblCategori.text = "How_would_you_categorize_it".localized()
        lblLocation.text = "Where_isit_at".localized()
        lblDetail.text = "What_are_all_the_details".localized()
    }
    
    func setData(){
        // self.showHud()
        dateInMillis = FeedJob["FromDate"].doubleValue
        JobID = FeedJob["JobId"].intValue
        self.txtCall.text = FeedJob["JobTitle"].stringValue
        self.txtDate.text = CommonStrings.getActivityDate(timeStamp: FeedJob["FromDate"].doubleValue)
        self.txtHours.text = FeedJob["HowLong"].stringValue
        self.txtAmount.text = FeedJob["Amount"].stringValue
        self.txtDetails.text = FeedJob["JobDescription"].stringValue
        txtDetails.textColor=UIColor.black
        txtCategori.text = FeedJob["JobCategory"].stringValue
        txtLocation.text = FeedJob["Location"].stringValue
        selectPlaceLate = FeedJob["Latitude"].doubleValue
        selectPlaceLong = FeedJob["Longitude"].doubleValue
        
        
        apiImageArr = Array(repeating: "", count: 3)
        // selectImageArr = Array(repeating: UIImage(named: "AddPhoto-Plus")!, count: 3)
        
        let dummyImage = UIImageView()
        
        if FeedJob["imageList"].arrayValue.count == 0 {
            //  self.hideHud()
            self.lblAddPhote.text = ""
        }
        
        self.imgCollection.reloadData()
        self.collectionWidth.constant = CGFloat(self.apiImageArr.count * 90)
        self.lblAddPhote.text = ""
        
        
        //        for index in 0..<FeedJob["imageList"].arrayValue.count{
        //            let json = FeedJob["imageList"].arrayValue[index]
        //            imagGroup.enter()
        //            imgDownload.downloadImgFromUrl(urlstr: FeedJob["imageList"][index]["ImageName"].stringValue) { (data) in
        //                dummyImage.image = UIImage(data: data)!
        //                self.selectImageArr.remove(at: index)
        //                self.selectImageArr.insert(dummyImage.image!, at: index)
        //                if json == self.FeedJob["imageList"].arrayValue.last{
        //                    self.collectionWidth.constant = CGFloat(self.apiImageArr.count * 90)
        //                    self.imgCollection.reloadData()
        //                    self.hideHud()
        //                    self.lblAddPhote.text = ""
        //                    self.imagGroup.leave()
        //                }
        //            }
        //        }
        
        
        
        
        
        //        imagGroup.notify(queue: .main) {
        //            self.imgCollection.reloadData()
        //            self.collectionWidth.constant = CGFloat(self.apiImageArr.count * 90)
        //            self.lblAddPhote.text = ""
        //        }
        
    }
    
    
    
    
    
    func downloadImage(url:String,index:Int) {
        let imageView = UIImageView()
        let url = URL(string:url)
        //  imgView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "noimage"), options: nil, progressBlock: nil) { result in
            let image = try? result.get().image
            if let image = image {
                
                self.selectImageArr.remove(at: index)
                self.selectImageArr.insert(image, at: index)
                self.syncInto.complete()
                
                if index == self.FeedJob["imageList"].arrayValue.count-1{
                    self.collectionWidth.constant = CGFloat(self.apiImageArr.count * 90)
                    self.imgCollection.reloadData()
                    self.hideHud()
                    self.lblAddPhote.text = ""
                }
            }
            else{
                imageView.image = #imageLiteral(resourceName: "noimage")
                self.syncInto.complete()
            }
        }
    }
    
    
    func getDateFromTimeStamp(timeStamp : Double) -> String {
        let date = NSDate(timeIntervalSince1970: Double(timeStamp) / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        formatter.dateFormat =  "MM/dd/yyyy"
        return (formatter.string(from: date as Date))
    }
    
    
    func getJobCategory(){
        let apiController : APIController = APIController()
        apiController.getRequest(methodName: "GetJobCategory",param: nil, isHUD: true) { (responce) in
            if responce["data"].arrayValue.count > 0{
                self.CategoryArr =  responce["data"].arrayValue.map { $0["CategoryName"].stringValue }
            }
        }
    }
    
    @IBAction func btnCamera(_ sender: Any) {
    }
    
    @IBAction func btnAddPhoto(_ sender: Any) {
    }
    
    @IBAction func btnDateWhatDoYouNeedIt(_ sender: Any) {
        placeholderView.isHidden = false
        
        
    }
    func didSelectDate(date: Date) {
        let countValue = date.month
        print(String(countValue).count)
        if String(countValue).count == 1{
            print("\("0" + String(date.month))-\(date.year)-\(date.day)")
            self.dateValue = "\("0" + String(date.month))-\(date.day)-\(date.year)"
            dateValueFormate = "\("0" + String(date.month))/\(date.day)/\(date.year)"
        }
        else{
            print("\(date.year)-\(date.month)-\(date.day)")
            self.dateValue = "\(date.month)-\(date.day)-\(date.year)"
            dateValueFormate = "\(date.month)/\(date.day)/\(date.year)"
        }
    }
    func didSelectDateView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let someDate = dateFormatter.date(from: dateValueFormate)
        
      
        
//        print(interval.day)
//        print(interval.month)
//        print(interval.hour)
        
        let interval = Date() - someDate!
        if interval.day! > 0 {
            CommonFunctions.showAlert(self, message: "Please don't use back date", title: appName)
        }
//        else if someDate! == Date() {
//            CommonFunctions.showAlert(self, message: "same date", title: appName)
//        }
        else{
            txtDate.text = dateValue
            placeholderView.isHidden = true
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func miliSecFromDate(date : String) -> String {
        let strTime = date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = .autoupdatingCurrent
        let ObjDate = formatter.date(from: strTime)
        return (String(describing: ObjDate!.millisecondsSince1970))
    }
    
    
    @IBAction func btnPost(_ sender: UIButton) {
        
        print(txtDetails.text!)
        //    print("dateInMillis",dateInMillis)
        if !valid() {
            return
        }
        
        self.dateInMillis = (self.miliSecFromDate(date: txtDate.text ?? "") as NSString).doubleValue + 84240000
        self.uploadImgUrl = []
        for img in selectImageArr{
            if img != UIImage(named: "AddPhoto-Plus"){
                self.uploadImage(image: img)
                self.syncInto.wait()
            }
        }
        var parms:[String:Any]?
        if self.uploadImgUrl.count > 0
        {
            parms =
                ["Id":"\(JobID)",
                 "UserId":"\(appDelegate.user_ID)",
                 "JobTitle":txtCall.text ?? "",
                 "HowLong":txtHours.text ?? "1-2 hours",
                 "Amount":txtAmount.text ?? "",
                 "JobCategory":txtCategori.text ?? "",
                 "Location":txtLocation.text ?? "",
                 "FromDate": "\(dateInMillis ?? 00)",
                 "JobDescription":txtDetails.text ?? "",
                 "Latitude":"\(selectPlaceLate ?? 00)",
                 "Longitude":"\(selectPlaceLong ?? 00)",
                 "imglist":"\(self.uploadImgUrl)"]
        }
        else
        {
            parms =
                ["Id":"\(JobID)",
                 "UserId":"\(appDelegate.user_ID)",
                 "JobTitle":txtCall.text ?? "",
                 "HowLong":txtHours.text ?? "",
                 "Amount":txtAmount.text ?? "",
                 "JobCategory":txtCategori.text ?? "",
                 "Location":txtLocation.text ?? "",
                 "FromDate": "\(dateInMillis ?? 00)",
                 "JobDescription":txtDetails.text ?? "",
                 "Latitude":"\(selectPlaceLate ?? 00)",
                 "Longitude":"\(selectPlaceLong ?? 00)",
                 
                 "imglist":""]
        }
        
        print(parms!)
        let apiController : APIController = APIController()
        apiController.postRequestWithDict(methodName: "CreateJob", params: parms!) { (responce) in
            if responce["message"].stringValue == "success"{
                
                
                Utilities.createShareLink(jobid: responce["data"]["Id"].stringValue, image: ""){ (result) in
                    
                    let paramsData =
                        [
                            "Id" : responce["data"]["Id"].intValue,
                            "applink" : "\(result.absoluteString)"
                        ] as [String : Any]
                    
                    apiController.getAppLink(params: paramsData){ (response) in
                        
                        print(response)
                        
                        if(responce["message"].stringValue == "success"){
                            DispatchQueue.main.async {
                                if self.isEdit{
                                    self.doneAlert(message: "Job Feed Update Successfully!")
                                }else{
                                    self.clearTextFromTxtvw(isTextSend: true)
                                    self.doneAlert(message: "Create_Job_Done".localized())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func uploadImage(image:UIImage){
        let apiController : APIController = APIController()
        apiController.uploadImages(image: image, methodName: "SaveJobImages") { (responce) in
            if responce["message"].stringValue == "success"{
                self.uploadImgUrl.append(responce["data"][0].stringValue)
                print(self.uploadImgUrl)
                self.syncInto.complete()
            }
        }
    }
    
    
    func doneAlert(message:String){
        let refreshAlert = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //            if self.isEdit{
            //               self.navigationController?.popToViewController(ofClass: MyListHomeViewController.self)
            //
            //            }
            //            else{
            // self.navigationController?.popViewController(animated: true)
            self.navigationController?.popToViewController(ofClass: HomeViewController.self)
            //            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func onAddCamera(_ sender: UIButton) {
        
        if self.selectImageArr.count < 3 {
            userModel.photoDelete = "true"
            self.imagePicker.presentWithDelete(from: sender)
            isEdit = false
        } else{
            Alert.alert(message: "Add photo maximum limit is 3".localized(), title: "Alert")
        }
        
    }
    
    
    @IBAction func onAddPhoto(_ sender: Any) {
        
        if self.selectImageArr.count < 3 {
            userModel.photoDelete = "true"
            self.imagePicker.presentWithDelete(from: sender as! UIView)
            isEdit = false
        } else{
            Alert.alert(message: "Add photo maximum limit is 3".localized(), title: "Alert")
        }
    }
    
    
    func valid() -> Bool{
        if (txtCall.text!.isEmpty){
            Alert.alert(message: "Please_enter_job_title".localized(), title: "Alert")
            return false
        }
        if (txtDate.text!.isEmpty){
            Alert.alert(message: "Please_enter_job_date".localized(), title: "Alert")
            
            return false
        }
        if (txtHours.text!.isEmpty){
            Alert.alert(message: "Please_enter_job_Time".localized(), title: "Alert")
            
            return false
        }
        if (txtAmount.text!.isEmpty){
            Alert.alert(message: "Please_enter_Amount".localized(), title: "Alert")
            
            return false
        }
        if (txtCategori.text!.isEmpty){
            Alert.alert(message: "Please_select_Job_Category".localized(), title: "Alert")
            return false
        }
        if (txtLocation.text!.isEmpty){
            Alert.alert(message: "Please_enter_location".localized(), title: "Alert")
            return false
        }
        print(txtDetails.text!.isEmpty)
        print((txtDetails.text! == "Enter the work details here"))
        
        if (txtDetails.text!.isEmpty) || (txtDetails.text! == "Enter the work details here"){
            Alert.alert(message: "Please_select_Job_Details".localized(), title: "Alert")
            return false
        }
        
        //        if selectImageArr.count == 1 {
        //            Alert.alert(message: "Please_select_job_image".localized(), title: "Alert")
        //            return false
        //        }
        
        return true
    }
    
    @IBAction func txtLocationTap(_ sender: UITextField) {
        txtLocation.resignFirstResponder()
        //let acController = GMSAutocompleteViewController()
        GMSAutocompleteVC.delegate = self
        present(GMSAutocompleteVC, animated: true, completion: nil)
    }
    
}

extension AddJobViewController : UITextViewDelegate{
    //    func textViewDidChange(_ textView: UITextView) {
    //        placeholderLabel.isHidden = true
    //    }
    
    // MARK: Textview delegates
    internal func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        if textView == txtDetails {
            if txtDetails.text == "Enter the work details here" {
                txtDetails.text=""
                txtDetails.textColor=UIColor.black
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtDetails {
            clearTextFromTxtvw(isTextSend: false)
        }
    }
    
    //MARK:- to clear Text after messaeg send
    func clearTextFromTxtvw(isTextSend: Bool){
        if isTextSend == true {
            txtDetails.text = "Enter the work details here"
            txtDetails.textColor = UIColor.lightGray
        }
        else {
            if(((txtDetails.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
                txtDetails.text = "Enter the work details here"
                txtDetails.textColor = UIColor.lightGray
            }
        }
        self.view.endEditing(true)
    }
    
    
    
}


extension AddJobViewController : UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate{
    
    func pickUp(_ textField : UITextField){
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        if traitCollection.userInterfaceStyle == .dark{
            self.pickerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }else{
            self.pickerView.backgroundColor = UIColor.white
        }
        //self.pickerView.backgroundColor = UIColor.white
        activeTextField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //    toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        activeTextField.inputAccessoryView = toolBar
        
        //--------------------------------New Code----------------------------------------------------------------
        
        if traitCollection.userInterfaceStyle == .dark{
            doneButton.tintColor = UIColor.white
            cancelButton.tintColor = UIColor.white
            spaceButton.tintColor = UIColor.white
        }else{
            doneButton.tintColor = UIColor.black
            cancelButton.tintColor = UIColor.black
            spaceButton.tintColor = UIColor.black
        }
        
    }
    
    
    @objc func doneClick() {
        if activeTextField == txtCategori{
            //            let indexPath = pickerView.selectedRow(inComponent: 0)
            activeTextField.text = CategoryArr[cateIndex]
            activeTextField.resignFirstResponder()
        }
        if activeTextField == txtHours{
            //            let FirstComponent = pickerView.selectedRow(inComponent: 0)
            //            let SecondComponent = pickerView.selectedRow(inComponent: 1)
            //            activeTextField.text = "\(HourCountArr[FirstComponent]) \(HourTypeArr[SecondComponent])"
            //            activeTextField.resignFirstResponder()
            let FirstComponent = pickerView.selectedRow(inComponent: 0)
            activeTextField.text = HowlongArr[HowlongIndex]
            activeTextField.resignFirstResponder()
            
        }
    }
    
    @objc func cancelClick() {
        activeTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if activeTextField == txtHours{
            return 1
        }
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == txtHours{
            return HowlongArr.count
        }
        return CategoryArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTextField == txtHours{
            return HowlongArr[row]
        }
        else {
            return CategoryArr[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if activeTextField == txtCategori{
            cateIndex = row
        }
        if activeTextField == txtHours{
            HowlongIndex = row
            // txtHours.text = "\(HourCountArr[hourIndex]) \(HourTypeArr[TypeIndex])"
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if activeTextField == txtCategori{
            self.pickUp(activeTextField)
        }
        if activeTextField == txtHours{
            self.pickUp(activeTextField)
        }
        if activeTextField == txtDate{
            self.pickUpDate(activeTextField)
        }
    }
    
    
    func pickUpDate(_ textField : UITextField){
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.minuteInterval = 15
        datePickerView.minimumDate = NSDate() as Date
        // datePickerView = datePickerView
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddJobViewController.doneTapped))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        if #available(iOS 13.4, *) {
            //            datePickerView.preferredDatePickerStyle = .wheels
        }
        //        self.txtDate.inputView = datePickerView
        //        self.txtDate.inputAccessoryView = toolBar
        datePickerView.addTarget(self, action: #selector(AddJobViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
    }
    
    @objc func doneTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        //        self.txtDate.text = dateFormatter.string(from: datePickerView.date)
        dateInMillis = datePickerView.date.millisecondsSince1970
        self.txtDate.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.txtDate.text = dateFormatter.string(from: sender.date)
        dateInMillis = datePickerView.date.millisecondsSince1970
        // _ = dateFormatter.string(from: sender.date) "MM/dd/yyyy"
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if activeTextField == txtCall{
            txtDate.becomeFirstResponder()
        }
        else if activeTextField == txtDate{
            txtHours.becomeFirstResponder()
        }
        else if activeTextField == txtHours{
            txtAmount.becomeFirstResponder()
        }
        else if activeTextField == txtAmount{
            txtCategori.becomeFirstResponder()
        }
        else if activeTextField == txtCategori{
            txtLocation.becomeFirstResponder()
        }
        else {
            txtDetails.becomeFirstResponder()
        }
        
        return true
    }
    
}


extension AddJobViewController: ImagePickerDelegate {
    func didDelete() {
        print(EditIndex)
        print(self.selectImageArr.count)
        
        self.selectImageArr.remove(at: EditIndex)
        if (self.selectImageArr.count == 0) {
            self.lblAddPhote.text = "Add Photo"
        }
        self.imgCollection.reloadData()
        //        DispatchQueue.main.async {
        //            print(self.selectImageArr.count)
        //            if self.selectImageArr.count == 0 {
        //                self.imgCollection.reloadData()
        //                self.selectImageArr.append(UIImage(named: "AddPhoto-Plus")!)
        //                self.viewWillAppear(true)
        //                }
        //                else{
        //
        //            }
        //        }
    }
    
    
    func didSelect(image: UIImage?) {
        if image != nil{
            
            if isEdit{
                self.selectImageArr.remove(at: EditIndex)
                self.selectImageArr.insert(image!, at: EditIndex)
                //
                //                self.apiImageArr.remove(at: EditIndex)
                //                self.apiImageArr.insert("https", at: EditIndex)
                DispatchQueue.main.async {
                    self.imgCollection.reloadData()
                }
                
            }else{
                
                self.selectImageArr.insert(image!, at: selectImageArr.count)
                if self.selectImageArr.count == 4 {
                    self.selectImageArr.remove(at: 3)
                }
                DispatchQueue.main.async {
                    self.lblAddPhote.text = ""
                    self.imgCollection.reloadData()
                    self.collectionWidth.constant = CGFloat(self.selectImageArr.count * 90)
                }
            }
            
        }
    }
}


extension AddJobViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        // txtLocation.text = place.name
        // print(place.coordinate.latitude)
        // print(place.coordinate.longitude)
        selectPlaceLate = place.coordinate.latitude
        selectPlaceLong = place.coordinate.longitude
        
        DispatchQueue.main.async {
            self.ManuallyLocationPopup(place: place)
        }
        
        //        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
    
    func ManuallyLocationPopup(place:GMSPlace){
        let refreshAlert = UIAlertController(title: "Address:\n\n\(place.formattedAddress ?? "")\n", message: "", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DispatchQueue.main.async {
                
                self.txtLocation.text = place.formattedAddress ?? ""
                self.GMSAutocompleteVC.dismiss(animated: true, completion: nil)
                
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        ServiceManager.topMostController().present(refreshAlert, animated: true, completion: nil)
        
    }
}


extension AddJobViewController : UICollectionViewDataSource, UICollectionViewDelegate,AddImageDelegate,UICollectionViewDelegateFlowLayout{
    
    func setImage(index: Int, parentview: UIView) {
        userModel.photoDelete = "false"
        EditIndex = index
        isEdit = true
        self.imagePicker.presentWithDelete(from: parentview)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectImageArr.count == 0 {
            self.lblAddPhote.text = "Add Photo"
        }
        //    if isEdit{ return apiImageArr.count }
        print(selectImageArr.count)
        
        return selectImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCollectionViewCell", for: indexPath) as! AddImageCollectionViewCell
        cell.delegate = self
        cell.parentVC = self
        
        //
        //        if isEdit{
        
        //            if self.selectImageArr[indexPath.item] == UIImage(named: "AddPhoto-Plus"){
        //                cell.btnCamera.isHidden = false
        //                cell.btnAddPhoto.isHidden = false
        //                cell.btnAddPhoto.setImage(#imageLiteral(resourceName: "AddPhoto-Plus"), for: .normal)
        //                cell.imgView.image  = nil
        //            }
        //
        //            else{
        
        cell.imgView.image = self.selectImageArr[indexPath.item]
        cell.btnCamera.isHidden = true
        cell.btnAddPhoto.isHidden = false
        cell.btnAddPhoto.setImage(#imageLiteral(resourceName: "EditProfile-EditIcon"), for: .normal)
        //            }
        
        return cell
        //        }
        
        //        else{
        //
        //            if indexPath.row < self.selectImageArr.count-1{
        //                cell.imgView.image =  self.selectImageArr[indexPath.item]
        //               cell.btnCamera.isHidden = true
        //                cell.btnAddPhoto.isHidden = false
        //                cell.btnAddPhoto.setImage(#imageLiteral(resourceName: "EditProfile-EditIcon"), for: .normal)
        //            }
        //            return cell
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    
    
}




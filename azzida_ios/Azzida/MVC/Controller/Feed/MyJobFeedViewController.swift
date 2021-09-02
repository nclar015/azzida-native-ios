//
//  MyJobFeedViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 08/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MyJobFeedViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var btnApplyConstant: NSLayoutConstraint!
    @IBOutlet weak var btnConfirmCancellation: UIButton!
    @IBOutlet weak var viewStripePaymentPopUpView: UIView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var viewDetail : UIView!
    @IBOutlet weak var btnApplyNow: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var jobImg : UIImageView!
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnDistance: UIButton!
    @IBOutlet weak var lblDescriptionTitle : UILabel!
    @IBOutlet weak var txtDescription : UITextView!
    @IBOutlet weak var slider: Slider!
    @IBOutlet weak var listerImg: UIImageView!
    @IBOutlet weak var lblListerName: UILabel!
    @IBOutlet weak var lblListerJobComp: UILabel!
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var btnCancelJob: UIButton!
    @IBOutlet weak var userViewTop: NSLayoutConstraint!
    //--------------------Updated Using Api-------------------
    @IBOutlet weak var lblHowLong: UILabel!
    @IBOutlet weak var lblJobCategory: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var addressHeight: NSLayoutConstraint!
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let Constant : CommonStrings = CommonStrings.commonStrings
    let userModel : UserModel = UserModel.userModel
    var jobID = 0
    var listJSON = JSON()
    var JobData = JSON()
    var isApplicationAccepted = false
    var isOfferAccepted = false
    var isComplete = false
    var currantlat: CLLocationDegrees!
    var currantlong:CLLocationDegrees!
    var titleStr = ""
    let textViewAlert = UITextView(frame: CGRect.zero)
    var listerName = ""
    var listerImage = ""
    var JobStatus = ""
    var locationManager:CLLocationManager!
    var pushData = [String:Any]()
    var stripePaymentPopup : Bool!
    var timeValue : String!
    var posterCancelRequest :Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stripePaymentPopup = true
        print(btnApplyNow.currentTitle)
        GetJobDetail()
        getUserLocation()
        viewDetail.cellBGViewShdow()
        btnChat.isHidden = true
        self.btnCancelJob.isHidden = true
        btnConfirmCancellation.isHidden = true
        btnApplyConstant.constant = 15
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.viewDetail.isUserInteractionEnabled = true
        self.viewDetail.addGestureRecognizer(labelTap)
        NotificationCenter.default.addObserver(self, selector: #selector(self.change_Request), name: NSNotification.Name(rawValue: "change_Request"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.Back_To_Feed), name: NSNotification.Name(rawValue: "Back_To_Feed"), object: nil)
        
        
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        
        btnDistance.setImage(#imageLiteral(resourceName: "JobListing-LocationPin").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        btnDistance.tintColor = .gray
        
        
        btnDate.setImage(#imageLiteral(resourceName: "Joblisting-Calander").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        btnDate.tintColor = .gray
        
        txtDescription.isEditable = false
        if self.traitCollection.userInterfaceStyle == .dark
        {
            self.lblListerJobComp.textColor = .white
        }
        else if self.traitCollection.userInterfaceStyle == .light
        {
            self.lblListerJobComp.textColor = .black
        }
        else
        {
            self.lblListerJobComp.textColor = .black
        }        // setTitles()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.appDel.isFromPush = false
    }
    
    @objc func setText(){
        self.lblDescriptionTitle.text = "Description".localized()
        self.btnTitle.setTitle("Back to \(titleStr)", for: .normal)
    }
    
    func getUserLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        
        self.currantlat = locValue.latitude
        self.currantlong = locValue.longitude
        
        if self.currantlat == 00 || self.currantlong == 00{
            // Alert.alert(message: "", title: "Location hi nhi aa rahi yarrr")
            return
        }
    }
    //
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func GetJobDetail(){
        var contentImages = [String]()
        
        if appDel.isFromPush{
            self.jobID = Int(pushData["JobId"] as? String ?? "0") ?? 0
        }
        
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "JobId":jobID,
            "UserId":appDel.user_ID
        ]
        apiController.getRequest(methodName: "GetJobDetail", param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success"{
                DispatchQueue.main.async {
                    self.JobData = responce["data"]
                    // self.jobImg.downloadImage(url: responce["data"]["imageList"][0]["ImageName"].stringValue)
                    self.addressHeight.constant = 0
                    
                    //IMAGE SLIDER
                    contentImages = responce["data"]["imageList"].arrayValue.map { $0["ImageName"].stringValue}
                    self.slider.slides = contentImages
                    self.slider.setupSliderView()
                    
                    //LISTER DATA ListerName
                    self.lblListerName.text = responce["data"]["ListerName"].stringValue
                    self.lblListerJobComp.text = "\(responce["data"]["ListerCompleteJob"].intValue) Jobs Completed"
                    self.listerImg.downloadImage(url: responce["data"]["ListerProfilePicture"].stringValue)
                    
                    self.listerName = responce["data"]["ListerName"].stringValue
                    self.listerImage = responce["data"]["ListerProfilePicture"].stringValue
                    self.posterCancelRequest = responce["data"]["IsPosterCancelRequest"].boolValue
                    self.lblTitle.text = responce["data"]["JobTitle"].stringValue
                    self.lblPrice.text = "$\(responce["data"]["Amount"].stringValue)"
                    self.txtDescription.text = responce["data"]["JobDescription"].stringValue
                    self.btnDate.setTitle(CommonStrings.getActivityDate(timeStamp: responce["data"]["FromDate"].doubleValue), for: .normal)
                    
                    //------------------Need To Update Here According To lblPrice-----------------------------------------------
                    
                    self.lblHowLong.text = "How long: \( responce["data"]["HowLong"].stringValue)"
                    self.lblJobCategory.text = "Job Category: \(responce["data"]["JobCategory"].stringValue)"
                    
                    //------------------------------------------------
                    
                    self.showlCordinate(late: responce["data"]["Latitude"].doubleValue, long: responce["data"]["Longitude"].doubleValue, location: responce["data"]["Location"].stringValue)
                    self.btnDistance.setTitle(Distance.getDistance(lat1: self.currantlat ?? 00, lon1: self.currantlong ?? 00, lat2: responce["data"]["Latitude"].doubleValue, lon2: responce["data"]["Longitude"].doubleValue), for: .normal)
                    if responce["data"]["IsApply"].boolValue{
                        //                        self.btnChat.setImage(#imageLiteral(resourceName: "MyJobListing-Chat"), for: .normal)
                        //                        self.btnChat.isHidden = false
                        self.btnApplyNow.setTitle("Application Pending", for: .normal)
                        self.btnApplyNow.backgroundColor = UIColor.lightGray
                        self.isApplicationAccepted = responce["data"]["ApplicationAccepted"].boolValue
                        self.isOfferAccepted = responce["data"]["OfferAccepted"].boolValue
                        self.isComplete = responce["data"]["IsComplete"].boolValue
                        self.btnCancelJob.isHidden = false
                        if(self.isOfferAccepted)
                        {
                            self.addressHeight.constant = 40
                            self.lblAddress.text = "Job Posting Address :- \(responce["data"]["Location"].stringValue)"
                        }
                        else
                        {
                            self.addressHeight.constant = 0
                        }
                        if self.isApplicationAccepted{
                            self.btnApplyNow.setTitle("Confirm Availability", for: .normal)
                            self.btnApplyNow.backgroundColor = self.Constant.theamGreenColor
                            self.btnCancelJob.isHidden = false
                            self.btnChat.setImage(#imageLiteral(resourceName: "MyJobListing-Chat"), for: .normal)
                            self.btnChat.isHidden = false
                            self.btnConfirmCancellation.isHidden = true
                            self.btnApplyConstant.constant = 15
                        }
                        if self.isOfferAccepted{
                            self.btnCancelJob.isHidden = false
                            self.btnChat.setImage(#imageLiteral(resourceName: "MyJobListing-Chat"), for: .normal)
                            self.btnChat.isHidden = false
                        }
                        if self.isComplete{
                            self.btnApplyNow.setTitle("Job Completed", for: .normal)
                            self.btnApplyNow.backgroundColor = .lightGray
                            self.btnApplyNow.setTitleColor(.white, for: .normal)
                            self.btnApplyNow.isEnabled = false
                            self.btnCancelJob.isHidden = true
                        }
                        if(self.isOfferAccepted)
                        {
                            self.btnApplyNow.setTitle("Complete Job", for: .normal)
                            if self.btnApplyNow.backgroundColor == .lightGray{
                                self.btnApplyNow.isEnabled = false
                                self.btnCancelJob.isHidden = true
                                self.btnConfirmCancellation.isHidden = true
                                self.btnApplyConstant.constant = 15
                            }else{
                                self.btnApplyNow.isEnabled = true
                                self.btnCancelJob.isHidden = false
                                if self.posterCancelRequest == true{
                                    self.btnConfirmCancellation.isHidden = false
                                    self.btnApplyConstant.constant = 80
                                    self.btnConfirmCancellation.backgroundColor = self.Constant.theamGreenColor
                                    self.btnCancelJob.isHidden = true
                                }
                                else{
                                    self.btnConfirmCancellation.isHidden = true
                                    self.btnApplyConstant.constant = 15
                                }
                            }
                            
                        }
                    }
                    if self.JobStatus == "Not Selected"{
                        self.btnCancelJob.isHidden = true
                        self.btnChat.isHidden = true
                        self.btnApplyNow.setTitle("Posting Closed", for: .normal)
                        self.btnApplyNow.backgroundColor = .lightGray
                        self.btnApplyNow.setTitleColor(.white, for: .normal)
                        self.btnApplyNow.isEnabled = false
                    }
                    print(self.btnApplyNow.currentTitle!)
                    print(self.btnApplyNow.isEnabled)
                }
            }
            
        }
    }
    
    func showlCordinate(late:Double,long:Double,location:String){
        if (late < -90 || late > 90) {
            print("invalid late long")
        }
        else if (long < -180 || long > 180) {
            print("invalid late long")
        }
        else{
            let coordinate = CLLocationCoordinate2DMake(late, long)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            let Annotation = MKPointAnnotation()
            //   Annotation.coordinate = coordinate
            Annotation.title = ""
            mapView.addAnnotation(Annotation)
            addRadiusCircle(location: CLLocation(latitude: late, longitude: long))           }
        
    }
    
    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: 1000 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = Constant.theamColor
            circle.fillColor = Constant.theamColor.withAlphaComponent(0.5)
            circle.lineWidth = 1
            return circle
        } else {
            return MKOverlayRenderer()
        }
    }
    
    
    
    
    @objc func change_Request(_ notification: NSNotification) {
        if (notification.userInfo?["status"] as? Bool) != nil {
            DispatchQueue.main.async {
                
                //                if self.userModel.UserMainActivity == "HomeViewController"{
                //                    self.navigationController?.popToViewController(ofClass: HomeViewController.self)
                //
                //                }
                //                else
                //                {
                self.navigationController?.popViewController(animated: true)
                //                }
            }
        }
    }
    
    @objc func Back_To_Feed(_ notification: NSNotification) {
        if (notification.userInfo?["status"] as? Bool) != nil {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        let vc = SecondStoryboard.instantiateViewController(withIdentifier: "JobPostedUserViewController") as! JobPostedUserViewController
        vc.ListerID = self.JobData["ListerId"].intValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnChat(_ sender: UIButton) {
        let vc = SecondStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.chatType = "MyJob"
        vc.FeedJSOn = self.JobData
        self.navigationController?.pushViewController(vc, animated:true)
        
    }
    @IBAction func btnConfirmCancellationJob(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "You hereby confirm that job has been cancelled and no work has been performed and no payment is due for completion of \(self.lblTitle.text!). If this cancellation request has been sent in error and your job has been completed, please click Cancel and contact the Job Poster through the Azzida Chat message system on the Job Details screen.", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive) { (action) in
            alertController.view.removeObserver(self, forKeyPath: "bounds")
        }
        alertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "I Agree", style: .default) { (action) in
            //            let enteredText = self.textViewAlert.text
            alertController.view.removeObserver(self, forKeyPath: "bounds")
            self.jobCancelApplicationAcceptRejectApi()
        }
        alertController.addAction(saveAction)
        
        alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
        //        textViewAlert.backgroundColor = UIColor.white
        //        textViewAlert.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
        //        textViewAlert.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        //        textViewAlert.addDoneButtonOnKeyboard()
        //        alertController.view.addSubview(self.textViewAlert)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelJob(_ sender: UIButton) {
        
        print(self.btnApplyNow.currentTitle!)
        print(self.btnApplyNow.isEnabled)
        print(self.btnApplyNow.backgroundColor == .lightGray )
        
        if (self.btnApplyNow.currentTitle == "Complete Job" && self.btnApplyNow.backgroundColor != .lightGray) || self.btnApplyNow.currentTitle == "Confirm Availability" || (self.btnApplyNow.currentTitle == "Application Pending"){
            
            
            if self.btnApplyNow.currentTitle == "Application Pending"{
                let alertController = UIAlertController(title: "Enter cancellation reason\n\n\n\n\n", message: "I hereby certify that the job has not been completed and that no payment is currently due", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive) { (action) in
                    alertController.view.removeObserver(self, forKeyPath: "bounds")
                }
                alertController.addAction(cancelAction)
                
                let saveAction = UIAlertAction(title: "I Agree", style: .default) { (action) in
                    let enteredText = self.textViewAlert.text
                    alertController.view.removeObserver(self, forKeyPath: "bounds")
                    self.cancelJobAPI(text: self.textViewAlert.text ?? "")
                }
                alertController.addAction(saveAction)
                
                alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
                textViewAlert.backgroundColor = UIColor.white
                textViewAlert.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
                textViewAlert.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                textViewAlert.addDoneButtonOnKeyboard()
                alertController.view.addSubview(self.textViewAlert)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                
                let alertController = UIAlertController(title: "Enter cancellation reason\n\n\n\n\n", message: "I hereby confirm that the job has not been completed and that no payment is due. If cancellation is made less than 24 hours before Job date, I understand that a cancellation fee may apply.", preferredStyle: .alert)
                let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive) { (action) in
                    alertController.view.removeObserver(self, forKeyPath: "bounds")
                }
                alertController.addAction(cancelAction)
                
                let saveAction = UIAlertAction(title: "I Agree", style: .default) { (action) in
                    let enteredText = self.textViewAlert.text
                    alertController.view.removeObserver(self, forKeyPath: "bounds")
                    self.cancelJobAPI(text: self.textViewAlert.text ?? "")
                }
                alertController.addAction(saveAction)
                
                alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
                textViewAlert.backgroundColor = UIColor.white
                textViewAlert.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
                textViewAlert.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                textViewAlert.addDoneButtonOnKeyboard()
                alertController.view.addSubview(self.textViewAlert)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            //            A cancellation fee may apply if cancellation is not made within 24 hours of Job Date. Please use the Chat feature above if you need to reschedule with the Job Poster.
        }
        else{
            let alertController = UIAlertController(title: "Enter cancellation reason\n\n\n\n", message: "", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive) { (action) in
                alertController.view.removeObserver(self, forKeyPath: "bounds")
            }
            alertController.addAction(cancelAction)
            
            let saveAction = UIAlertAction(title: "Submit", style: .default) { (action) in
                let enteredText = self.textViewAlert.text
                alertController.view.removeObserver(self, forKeyPath: "bounds")
                self.cancelJobAPI(text: self.textViewAlert.text ?? "")
            }
            alertController.addAction(saveAction)
            
            alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
            textViewAlert.backgroundColor = UIColor.white
            textViewAlert.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
            textViewAlert.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            textViewAlert.addDoneButtonOnKeyboard()
            alertController.view.addSubview(self.textViewAlert)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds"{
            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                let margin: CGFloat = 8
                let xPos = rect.origin.x + margin
                let yPos = rect.origin.y + 54
                let width = rect.width - 2 * margin
                let height: CGFloat = 90
                
                textViewAlert.frame = CGRect.init(x: xPos, y: yPos, width: width, height: height)
            }
        }
    }
    func currentTimeInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        timeValue =  String(CLong(since1970 * 1000))
        return Int(since1970 * 1000)
    }
    func jobCancelApplicationAcceptRejectApi(){
        currentTimeInMiliseconds()
        //        if text.isEmpty {
        //            Alert.alert(message: "", title: "Enter cancellation reason")
        //            return
        //        }
        
        let param : [String:Any] = ["UserId":appDelegate.user_ID,"JobId":jobID,"IsAccept":"true","DateReply":timeValue!]
        
        let apiController : APIController = APIController()
        apiController.jobCancelApplicationAcceptReject(params: param) { (responce) in
            if responce["message"].stringValue == "success"{
                self.doneAlert(message: "Successfully cancellation job")
                self.viewWillAppear(true)
            }
        }
        
    }
    func cancelJobAPI(text:String){
        currentTimeInMiliseconds()
        if text.isEmpty {
            Alert.alert(message: "", title: "Enter cancellation reason")
            return
        }
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "CancelJobById?JobId=\(jobID)&Reason=\(text)&UserId=\(appDelegate.user_ID)&DateRequest=\(timeValue!)") { (responce) in
            if responce["message"].stringValue == "success"{
                self.doneAlert(message: "Job Cancel Successfully!")
                self.viewWillAppear(true)
            }
        }
    }
    
    func doneAlert(message:String){
        let refreshAlert = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        //        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        //        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func addActionBtn(_ sender: Any) {
        stripePaymentPopup = false
        viewStripePaymentPopUpView.isHidden = true
        JobApplication()
        
    }
    
    @IBAction func closeActionBtn(_ sender: Any) {
        viewStripePaymentPopUpView.isHidden = true
        stripePaymentPopup = false
        
    }
    @IBAction func btnApplyNow(_ sender: UIButton) {
        print(btnApplyNow.currentTitle)
        if appDel.user_ID == 0 {
            checkLogin.MovoToLogin(viewController: self)
            return
        }
        
        if btnApplyNow.currentTitle == "Complete Job"{
            if self.isComplete{
                // JobComplete()
            }else{
                let alert = UIAlertController(title: "", message: "I hereby confirm that \(self.lblTitle.text!) for \(self.listerName) has been completed.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                
                alert.addAction(UIAlertAction(title: "I Agree", style: .default, handler: { action in
                    self.JobComplete()
                }))
                
                self.present(alert, animated: true)
                
            }
        }
        else if btnApplyNow.currentTitle == "Apply Now"{
            
            JobApplication()
        }
        else if btnApplyNow.currentTitle == "Confirm Availability"{
            if isApplicationAccepted{
                let alert = UIAlertController(title: "", message: "Are you sure to confirm availability", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                    self.OfferAccepted()
                }))
                
                self.present(alert, animated: true)
            }else{
                //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobListPopUpVC") as! JobListPopUpVC
                //                vc.modalPresentationStyle = .overFullScreen
                //                vc.actionType = "Offer_Not_Accepted"
                //                self.present(vc, animated: false, completion: nil)
            }
        }else if btnApplyNow.currentTitle == "Application Pending"{
            
        }
    }
    
    func JobApplication(){
        if appDel.user_ID == 0 {
            return
        }
        
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "UserId":appDel.user_ID
        ]
        apiController.getRequest(methodName: "GetProfile",param: param, isHUD: false) { (responce) in
            if responce["message"].stringValue == "success" {
                self.userModel.stripeAccId = responce["data"]["StripeAccId"].stringValue
                print(self.userModel.stripeAccId)
                
                if(self.userModel.stripeAccId == "")
                {
                    if self.stripePaymentPopup == true{
                        
                        self.viewStripePaymentPopUpView.isHidden = false
                    }else{
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
                            let webViewController:WebViewController = Mainstoryboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                            webViewController.delegate = self
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
                else
                {
                    self.applicationAcceptedApi()
                    
                }
            }
        }
    }
    
    func applicationAcceptedApi(){
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "JobApplication?id=0&SeekerId=\(self.appDel.user_ID)&ListerId=\(self.JobData["ListerId"].intValue)&JobId=\(self.JobData["JobId"].intValue)&IsApply=true&applink=") { (responce) in
            if responce["message"].stringValue == "success"{
                DispatchQueue.main.async {
                    self.btnApplyNow.setTitle("Application Pending", for: .normal)
                    self.btnApplyNow.backgroundColor = UIColor.lightGray
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobListPopUpVC") as! JobListPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.actionType = "Application Complete. You will be notified if your application is accepted."
                    self.present(vc, animated: false, completion: nil)
                    // self.appDel.myJobRquest = "Thank_for_Applying" button title applictaion pending gray color
                }
            }
        }
        
    }
    
    func linkAccount(code:String, accountNumber:String) {
        //        http://13.72.77.167:8086/api/RetrieveStripeAccount?code=&userid=&accountnumber=
        let param : [String:Any] = ["code":code,"userid":self.userModel.Id,"accountnumber":accountNumber,"TokenUsed":AppTokenUsed.tokenUsed]
        
        print(param)
        let apiController : APIController = APIController()
        apiController.linkAccount(params: param, successHandler: { (json) in
            if json["message"].stringValue == "success"{
                self.applicationAcceptedApi()
                self.userModel.stripeAccId = accountNumber
                print(self.userModel.stripeAccId)
                
                //                DispatchQueue.main.async {
                //                    self.navigationController?.popViewController(animated: true)
                //                }
                
            }
        })
    }
    
    func OfferAccepted(){
        //JobId, SeekerId, ListerId, IsAcceptedbySeeker
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "OfferAccept?JobId=\(self.JobData["JobId"].intValue)&SeekerId=\(appDel.user_ID)&ListerId=\(self.JobData["ListerId"].intValue)&IsAcceptedbySeeker=true&applink=") { (responce) in
            if responce["message"].stringValue == "success"{
                self.isOfferAccepted = true
                DispatchQueue.main.async {
                    self.btnApplyNow.setTitle("Complete Job", for: .normal)
                    self.btnApplyNow.backgroundColor = self.Constant.theamGreenColor
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobListPopUpVC") as! JobListPopUpVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.actionType = "Offer_Accepted"
                    self.present(vc, animated: false, completion: nil)
                    self.btnCancelJob.isHidden = false
                    self.btnChat.setImage(#imageLiteral(resourceName: "MyJobListing-Chat"), for: .normal)
                    self.btnChat.isHidden = false
                    // self.appDel.myJobRquest = "Thank_for_Applying"  cancel job and char icon
                }
            }
        }
    }
    
    func JobComplete(){
        
        let currentTime = NSDate().timeIntervalSince1970 * 1000
        let currantTimeStr: String = String(format: "%.f", currentTime)
        
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "JobComplete?Id=\(self.JobData["JobId"].intValue)&CompleteDate=\(currantTimeStr)&IsComplete=true") { (responce) in
            if responce["message"].stringValue == "success"{
                self.isOfferAccepted = true
                self.isComplete = true
                //                self.btnApplyNow.setTitle("Job Completed", for: .normal)
                //                self.btnApplyNow.backgroundColor = .lightGray
                //                self.btnApplyNow.isEnabled = false
                //                self.btnCancelJob.isHidden = true
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotMyJobPopUpVC") as! NotMyJobPopUpVC
                    vc.JobData = self.JobData
                    vc.listerName = self.listerName
                    vc.listerImage = self.listerImage
                    vc.modalPresentationStyle = .overFullScreen
                    self.btnApplyNow.isEnabled = false
                    self.viewWillAppear(true)
                    self.present(vc, animated: false, completion: nil)
                }
            }
        }
    }
}

extension MyJobFeedViewController:WebViewControllerDelegate
{
    func getAccount(code: String) {
        self.linkAccount(code: code, accountNumber: "")
    }
}

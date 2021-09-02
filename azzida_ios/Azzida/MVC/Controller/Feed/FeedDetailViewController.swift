//
//  FeedDetailViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 05/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class FeedDetailViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,MBProgressHUDDelegate {
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let Constant : CommonStrings = CommonStrings.commonStrings
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var btnCancelApplicationTop: NSLayoutConstraint!
    @IBOutlet weak var constraintMap: NSLayoutConstraint!
    @IBOutlet weak var btnCancelApplication: UIButton!
    @IBOutlet weak var btnApplications : UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var jobImg : UIImageView!
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnDistance: UIButton!
    @IBOutlet weak var lblDescriptionTitle : UILabel!
    @IBOutlet weak var txtDescription : UITextView!
    @IBOutlet weak var slider: Slider!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var btnCancelJob: UIButton!
    //@IBOutlet weak var btnCancelJobTop: NSLayoutConstraint!
    @IBOutlet weak var btnCancelJobTop: NSLayoutConstraint!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblFeesTitle: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    
    
    //-----------------------Updated Code-------------------
    
   
    @IBOutlet weak var lblHowLong: UILabel!
    @IBOutlet weak var lblJobCatogry: UILabel!
    
    //------------------------Updated Code-------------------
    
//    @IBOutlet weak var btnApplicationHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var btnCancelJobHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnApplicationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCancelJobHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCancleJobTopSpacing: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblFees: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    
//    vc.jobID = data[indexPath.row]["JobId"].intValue
//    vc.currantlat = self.userModel.currantlat
//    vc.currantlong = self.userModel.currantlong
//    vc.titleStr = "My Listing"
//    vc.hideBtn = 1
    

    var locationManager:CLLocationManager!
    var jobID = 0
    var currantlat: CLLocationDegrees!
    var currantlong:CLLocationDegrees!
    var JobData = JSON()
    let syncInto = SyncBlock()
    var selectImageArr : [UIImage] = []
     var selectImageArrValue : [UIImage] = []
    var HUD:MBProgressHUD!
    var titleStr = ""
    let textViewAlert = UITextView(frame: CGRect.zero)
    var pushData = [String:Any]()
    let userModel : UserModel = UserModel.userModel
    var hideBtn = 1
    var SeekerName = ""
    var posterCancelRequest = ""
    var timeValue : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addHUD()
              NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
              self.setText()
        btnCancelApplication.isHidden = true
        constraintMap.constant = -50
              btnShare.isHidden = true
              
              //---------------------Btn cancle----------
              if hideBtn == 0 {
                  btnCancelJob.isHidden = true
                  btnApplications.isEnabled = false
                  //\btnApplications.titleLabel?.text = "Job Completed"
                  btnEdit.isHidden = true
                  //btnApplicationHeightConstraint.constant = 0
                  btnCancelJobHeightConstraint.constant = 0
                 // btnCancleJobTopSpacing.constant = 0
              }
              if hideBtn == 1 {
                  btnCancelJob.isHidden = false
                  //btnApplications.isHidden = false
                  btnEdit.isHidden = false
                  //btnApplicationHeightConstraint.constant = 0
                  //btnCancelJobHeightConstraint.constant = 0
              }
              
              
              
              mapView.delegate = self
              mapView.mapType = .standard
              mapView.isZoomEnabled = true
              mapView.isScrollEnabled = true
              
              
              btnDistance.setImage(#imageLiteral(resourceName: "JobListing-LocationPin").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
              btnDistance.tintColor = .gray
              
              btnDate.setImage(#imageLiteral(resourceName: "Joblisting-Calander").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
              btnDate.tintColor = .gray
              
              lblHowLong.textColor = UIColor.gray
              lblJobCatogry.textColor = UIColor.gray
              
              txtDescription.isEditable = false
        
        getUserLocation()
        GetJobDetail()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.appDel.isFromPush = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        selectImageArrValue.removeAll()
    }
    //ApplicationAccepted = true = hide moth
    // ApplicationAccepted = false = 8 Alli = share
    //OfferAccepted = true = comfirm buuton = chat
    
    
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
        print(pushData["JobId"])
        if appDel.isFromPush{
            self.jobID = Int(pushData["JobId"] as? String ?? "0") ?? 0
        }
        
        selectImageArr = Array(repeating: UIImage(named: "AddPhoto-Plus")!, count: 3)
        var contentImages = [String]()
print(jobID)
        print(appDel.user_ID)
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "JobId":jobID,
            "UserId":appDel.user_ID
        ]
        apiController.getRequest(methodName: "GetJobDetail", param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success"{
                DispatchQueue.main.async {
                    self.JobData = responce["data"]
                    self.userModel.ListerJobData = responce["data"]
                    
                    contentImages = responce["data"]["imageList"].arrayValue.map { $0["ImageName"].stringValue}
                    
                    self.slider.slides = contentImages
                    self.slider.setupSliderView()
                    
                    self.jobImg.downloadImage(url: responce["data"]["imageList"][0]["ImageName"].stringValue)
                    
                    self.lblTitle.text = responce["data"]["JobTitle"].stringValue
                    self.lblPrice.text = "$\(responce["data"]["Amount"].stringValue)"
                    self.txtDescription.text = responce["data"]["JobDescription"].stringValue
                    self.SeekerName = responce["data"]["SeekerName"].stringValue
                    self.posterCancelRequest = responce["data"]["IsPosterCancelRequest"].stringValue
                    self.btnDate.setTitle(CommonStrings.getActivityDate(timeStamp: responce["data"]["FromDate"].doubleValue), for: .normal)
                    
                    //---------------------Updated Code---------------------

                    self.lblJobCatogry.text = "Job Category: \( responce["data"]["JobCategory"].stringValue)"
                    
                    
                    
                    self.lblHowLong.text = "How long: \( responce["data"]["HowLong"].stringValue)"
                    
                    //------------------------------------------------------
                    self.showlCordinate(late: responce["data"]["Latitude"].doubleValue, long: responce["data"]["Longitude"].doubleValue, location: responce["data"]["Location"].stringValue)
                    
                    self.btnDistance.setTitle(Distance.getDistance(lat1: self.currantlat ?? 00, lon1: self.currantlong ?? 00, lat2: responce["data"]["Latitude"].doubleValue, lon2: responce["data"]["Longitude"].doubleValue), for: .normal)
                    if(self.hideBtn != 0){
                        
                    if responce["data"]["ApplicationAccepted"].boolValue{
                        self.btnShare.setImage(#imageLiteral(resourceName: "MyJobListing-Chat"), for: .normal)
                        self.btnShare.isHidden = false
                        self.btnApplications.setTitle("Pending Confirmation", for: .normal)
                        self.btnApplications.backgroundColor = .lightGray
                        self.btnApplications.setTitleColor(.white, for: .normal)
                        self.btnApplications.isEnabled = false
                        self.btnEdit.isHidden = true
                        self.btnCancelApplication.isHidden = false
                        self.btnCancelApplicationTop.constant = 15
                        self.constraintMap.constant = 20
                        
                    }else{
                        self.btnShare.isHidden = false
                        self.btnShare.setImage(#imageLiteral(resourceName: "MyJobListing-Share"), for: .normal)
                        self.btnApplications.setTitle("\(responce["data"]["ApplicantCount"].stringValue ) " + "Applications".localized(), for: .normal)
                        self.btnApplications.isEnabled = true
                        self.btnApplications.backgroundColor = self.Constant.theamGreenColor
                        if(responce["data"]["ApplicantCount"].intValue > 0)
                        {
                            self.btnEdit.isHidden = true
                        }
                        
                        
                    }
                    
                    if responce["data"]["OfferAccepted"].boolValue{
                        self.btnApplications.setTitle("Confirm Completion", for: .normal)
                        self.btnApplications.backgroundColor = .lightGray
                        self.btnApplications.setTitleColor(.white, for: .normal)
                        self.btnShare.setImage(#imageLiteral(resourceName: "MyJobListing-Chat"), for: .normal)
                        self.btnShare.isHidden = false
                        self.btnApplications.isEnabled = false
                        self.btnCancelJob.isHidden = false
                        self.btnCancelJobTop.constant = 80
                        self.btnEdit.isHidden = true
                        self.btnCancelApplicationTop.constant = -50
                        self.btnCancelApplication.isHidden = true
                        

                    }
                    
                    if responce["data"]["IsComplete"].boolValue{
                        self.btnApplications.setTitle("Confirm Completion", for: .normal)
                        self.btnApplications.backgroundColor = self.Constant.theamGreenColor
                        self.btnApplications.isEnabled = true
                        self.btnCancelJob.isHidden = true
                        self.btnCancelJobTop.constant = 15
//                        self.btnCancelApplicationTop.constant = -50
//                        self.btnCancelApplication.isHidden = true
                       
                        
                    }
                }
                    //----------------------------
                    // SET JOB RE-PPST
                    if responce["data"]["Status"].stringValue == "Expired" || responce["data"]["Status"].stringValue == "Cancelled"{
                        self.btnCancelJobTop.constant = 15
                        self.btnApplications.isHidden = true
                        self.btnEdit.isHidden = true
                        self.btnShare.isHidden = true
                        self.btnCancelJob.setTitle("Re-post Job ", for: .normal)
                        self.btnCancelJob.backgroundColor = self.Constant.theamGreenColor
                        self.btnCancelJob.setTitleColor(.white, for: .normal)

                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        if(self.btnApplications.titleLabel?.text == "Job Completed")
                        {
                            self.btnApplications.backgroundColor = self.Constant.theamGreenColor
                        }
                    }
                    
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
           // Annotation.coordinate = coordinate
          //  Annotation.title = ""
            mapView.addAnnotation(Annotation)
            addRadiusCircle(location: CLLocation(latitude: late, longitude: long))
        }
        
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
    
    
    @objc func setText(){
        self.lblDescriptionTitle.text = "Description".localized()
        self.btnTitle.setTitle("Back to \(titleStr)", for: .normal)
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//          let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//
//          mapView.mapType = MKMapType.standard
//
//          let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//          let region = MKCoordinateRegion(center: locValue, span: span)
//          mapView.setRegion(region, animated: true)
//
//          let annotation = MKPointAnnotation()
//          annotation.coordinate = locValue
//        //  annotation.title = "Javed Multani"
//         // annotation.subtitle = "current location"
//          mapView.addAnnotation(annotation)
//
//          //centerMap(locValue)
//      }
//
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnApplications(_ sender: UIButton) {
        if btnApplications.currentTitle == "Confirm Completion"{
            
            let vc = SecondStoryboard.instantiateViewController(withIdentifier: "FeedJobJustCompletedVC") as! FeedJobJustCompletedVC
            vc.FeedJson = self.JobData
            vc.PaymentType = "Tip"
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else{
            let vc = SecondStoryboard.instantiateViewController(withIdentifier: "ViewApplicantsViewController") as! ViewApplicantsViewController
            vc.jobId = jobID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionCancelApplication(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter cancellation reason\n\n\n\n\n", message: "You hereby confirm that \(SeekerName) has not completed \(self.lblTitle.text!) and no payment is due at this time.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive) { (action) in
            alertController.view.removeObserver(self, forKeyPath: "bounds")
        }
        alertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "I Agree", style: .default) { (action) in
            let enteredText = self.textViewAlert.text
            alertController.view.removeObserver(self, forKeyPath: "bounds")
            self.cancelApplicationApi(text: self.textViewAlert.text ?? "")
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
    @IBAction func btnEdit(_ sender: UIButton) {
        //        let vc = Mainstoryboard.instantiateViewController(withIdentifier: "AddJobViewController") as! AddJobViewController
        //        vc.isEdit = true
        //        vc.FeedJob =  self.JobData
        //        vc.selectImageArr = selectImageArr
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        
        showHud()
        print(self.selectImageArr)
        for index in 0..<JobData["imageList"].arrayValue.count{
            let json = JobData["imageList"].arrayValue[index]
            
            self.downloadImage(url: JobData["imageList"][index]["ImageName"].stringValue, index: index)
//            selectImageArr.append(UIImage: json)
            self.syncInto.wait()
            print(self.selectImageArr)
        }
        
        self.hideHud()
        print(self.selectImageArr)
        let vc = Mainstoryboard.instantiateViewController(withIdentifier: "AddJobViewController") as! AddJobViewController
        print(self.selectImageArr)
        print(UIImage(named: "AddPhoto-Plus")!)
        for img in selectImageArr{
            if img != UIImage(named: "AddPhoto-Plus"){
        print(img)
        self.selectImageArrValue.append(img)
        print(self.selectImageArrValue)
//        self.uploadImage(image: img)
//         self.syncInto.wait()
    }
}
        print(self.selectImageArr)
        print(self.selectImageArrValue)
      
        vc.isEdit = true
        vc.FeedJob =  self.JobData
        vc.selectImageArr = self.selectImageArrValue
        self.navigationController?.pushViewController(vc, animated: true)
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
    @IBAction func btnCancelJob(_ sender: UIButton) {
        if btnCancelJob.currentTitle == "Cancel Job"{
            self.JobCancelAlert()
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobRePostViewController") as! JobRePostViewController
            vc.delegate = self
            vc.JobID = self.jobID
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
            
        }
    }
    
    func JobCancelAlert(){
        if self.btnApplications.currentTitle == "Pending Confirmation"{
            let alertController = UIAlertController(title: "Enter cancellation reason\n\n\n\n\n", message: "You hereby confirm that \(SeekerName) has not completed \(self.lblTitle.text!) and no payment is due at this time.", preferredStyle: .alert)
            
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
        else if self.btnApplications.currentTitle == "Confirm Completion"{
            if self.posterCancelRequest == "true"{
                doneAlert(message: "Cancel request has been sent already.")
            }else{
            let alertController = UIAlertController(title: "Enter cancellation reason\n\n\n\n\n", message: "You hereby confirm that \(SeekerName) has not completed the job and no payment is due at this time. Please contact the Job Performer through the Azzida Chat message system on the Job Details screen if Cancellation is not confirmed within 24 hours.", preferredStyle: .alert)
            
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
        }
        else{
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
    func cancelApplicationApi(text:String){
        if text.isEmpty {
            Alert.alert(message: "", title: "Enter cancellation reason")
            return
        }
        let param : [String:Any] = ["UserId":appDelegate.user_ID,"JobId":jobID]
        
        
        let apiController : APIController = APIController()
        apiController.cancelSeekerJobApplication(params: param) { (responce) in
            if responce["message"].stringValue == "success"{
                self.doneAlert(message: "Job Application Cancel Successfully!")
                self.viewWillAppear(true)
            }
        }
//        let apiController : APIController = APIController()
//        apiController.postRequest(methodName: "CancelSeekerJobApplication?UserId=\(appDelegate.user_ID)&JobId=\(jobID)") { (responce) in
//            if responce["message"].stringValue == "success"{
//                self.doneAlert(message: "Job Cancel Successfully!")
//                self.viewWillAppear(true)
//            }
//        }
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
    
    @IBAction func btnShare(_ sender: UIButton) {
        
        if btnShare.currentImage! == #imageLiteral(resourceName: "MyJobListing-Chat"){
            let vc = SecondStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.chatType = "MyListing"
            vc.FeedJSOn = self.JobData
            self.navigationController?.pushViewController(vc, animated:true)
        }
        else{
            let imageLink = JobData["data"]["imageList"].arrayValue.first?.stringValue ?? ""
            Utilities.createShareLink(jobid: "\(self.jobID)", image: imageLink) { (url) in
                DispatchQueue.main.async {
                    let shareString = "Here's a job posting that may be of interest to you\n\n\(url)\n\n"
                    let items = [shareString]
                    if UIDevice.current.localizedModel == "iPhone" {
                        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        print(ac)
                        self.present(ac, animated: true)
                    } else if UIDevice.current.localizedModel == "iPad" {
                        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
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
            }
        }
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
                
            }
            else{
                imageView.image = #imageLiteral(resourceName: "noimage")
                self.syncInto.complete()
            }
        }
    }
}


extension FeedDetailViewController: JobRepostDelegate{
    func dismisViewController() {
        self.navigationController?.popToViewController(ofClass: HomeViewController.self)
    }
    
}

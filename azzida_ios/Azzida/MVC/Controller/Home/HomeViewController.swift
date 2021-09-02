//
//  HomeViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 27/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import SideMenu
import Kingfisher
import CoreLocation
import GooglePlaces
import AppTrackingTransparency
import AdSupport

class HomeViewController: UIViewController,UIGestureRecognizerDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate,UITextFieldDelegate {
    
    var settings = SideMenuSettings()
    let constant : CommonStrings = CommonStrings.commonStrings
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let userModel : UserModel = UserModel.userModel
    
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var btnAddJob: UIButton!
    @IBOutlet var locationPopup: UIView!
    @IBOutlet var tblTop: NSLayoutConstraint!
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var txtcrash: UITextField!
    
    
    lazy var data : [JSON] = []
    var currantlat: CLLocationDegrees!
    var currantlong:CLLocationDegrees!
    var HUD:MBProgressHUD!
    var locationTitle =  UIButton(type: .custom)
    var isSearch = false
    var Showlabel = UILabel()
    var locationManager:CLLocationManager!
    var locationUpdating : Bool!
    let GMSAutocompleteVC = GMSAutocompleteViewController()
    var result = String()
    //   let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertLabel()
        titleview()
        
        appDel.JobType = "JobFeed"
        HUD = MBProgressHUD(view:self.view)
        HUD.color = UIColor(displayP3Red: 47/255, green: 97/255, blue: 173/255, alpha: 1.0)
        //  HUD.mode = .indeterminate
        HUD.delegate = self
        HUD.labelText = "fetching Please wait..."
        self.view.addSubview(HUD!)
        
        // getcurrentLatlong()
        //        getUserLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        tblView.register(UINib(nibName: "JobTableViewCell", bundle: nil), forCellReuseIdentifier: "JobTableViewCell")
        
        txtLocation.delegate = self
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForground(notification:)), name: Notification.Name("WillEnterForground"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        initButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestIDFA()
        //         getcurrentLatlong()
        getUserLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.hideHud()
        }
    }
    
    @objc func willEnterForground(notification:Notification) {
        //        self.viewDidLoad()
    }
    //REQUEST APP Tacking From User
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
                
                // Load your add here
            })
        } else {
            // Fallback on earlier versions
        }
    }
    func getUserLocation(){
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationUpdating = true
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
        
        if userModel.ManuallyLocation != "" {
            self.locationTitle.setTitle(userModel.ManuallyLocationTop, for: .normal)
            return
        }
        
        self.userModel.currantlat = locValue.latitude
        self.userModel.currantlong = locValue.longitude
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            if self.locationUpdating == true {
                self.locationUpdating = false
                //  self.googleAPIForAddress(late: locValue.latitude, long: locValue.longitude)
                self.hideHud()
                self.getAddress(late: locValue.latitude, long: locValue.longitude)
                self.UpdateUserLatLong(late: locValue.latitude, long: locValue.longitude)
            }
        }
        
    }
    //
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func getAddress(late:CLLocationDegrees,long:CLLocationDegrees){
        AddressModel().GetAddressFromLatLong(late: late, long: long) { (address) in
            self.locationTitle.setTitle(address, for: .normal)
            self.userModel.ManuallyLocationTop = address
        }
    }
    
    
    func FeedAPI(){
        if !self.isSearch{
            self.getLsting()
        }else{
            self.hideHud()
        }
    }
    
    func UpdateUserLatLong(late:CLLocationDegrees,long:CLLocationDegrees){
        if(appDel.user_ID != 0)
        {
            if late == 0 && long == 0{
                //                late = 37.5407
                //                long = 77.4360
                let apiController : APIController = APIController()
                apiController.postRequest(methodName: "UpdateUserLatLong?UserId=\(appDel.user_ID)&Latitude=\(37.5407)&Longitude=\(77.4360)") { (responce) in
                    if responce["message"].stringValue == "success" {
                        self.getJobCategory()
                        self.getUserProfile()
                        
                        self.FeedAPI()
                    }
                }
            }
            else{
                let apiController : APIController = APIController()
                apiController.postRequest(methodName: "UpdateUserLatLong?UserId=\(appDel.user_ID)&Latitude=\(late)&Longitude=\(long)") { (responce) in
                    if responce["message"].stringValue == "success" {
                        self.getJobCategory()
                        self.getUserProfile()
                        
                        self.FeedAPI()
                    }
                }
            }
        }
        else{
            self.getJobCategory()
            self.getUserProfile()
            
            self.FeedAPI()
        }
    }
    
    
    
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            //print("Swipe Right")
            self.performSegue(withIdentifier: "SideMenu", sender: self)
            
        }
        if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            //print("Swipe Right")
            self.showFilter()
        }
    } //SideMenu
    
    
    func initButton(){
        if  appDel.JobType == "MyListing" {
            btnAddJob.isHidden = false
            tblTop.constant = 75
        }
        else  {
            //            btnAddJob.isHidden = true
            //            tblTop.constant = 20
            btnAddJob.isHidden = false
            tblTop.constant = 75
        }
    }
    
    func titleview(){
        locationTitle.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        locationTitle.backgroundColor = .clear
        locationTitle.setTitle("Location", for: .normal)
        locationTitle.titleLabel?.textColor = .white
        locationTitle.imageEdgeInsets = UIEdgeInsets(top: 0, left: -60, bottom: 0, right: 0)
        locationTitle.titleEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        locationTitle.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        locationTitle.setImage(#imageLiteral(resourceName: "header-location-Pin"), for: .normal)
        locationTitle.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = locationTitle
        
        locationPopup.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(locationPopup)
        locationPopup.isHidden = true
        
        
        let tapLocationView = UITapGestureRecognizer(target: self, action: #selector(self.tapLocationView))
        locationPopup.isUserInteractionEnabled = true
        locationPopup.addGestureRecognizer(tapLocationView)
    }
    
    func alertLabel(){
        Showlabel = UILabel(frame: CGRect(x: 0, y: view.frame.size.height/2 - 50, width: view.frame.width, height: 100))
        Showlabel.textAlignment = .center
        Showlabel.numberOfLines = 0
        Showlabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        Showlabel.textColor = .gray
        self.view.addSubview(Showlabel)
        Showlabel.isHidden = true
        //  Showlabel.text = text
    }
    
    func hideLabel(text:String,bool:Bool){
        Showlabel.text = text
        Showlabel.isHidden = bool
    }
    
    
    @objc func setText(){
        self.title = "My_Jobs".localized()
    }
    
    @objc func clickOnButton() {
        if !locationPopup.isHidden {
            return
        }
        
        if userModel.ManuallyLocation != "" {
            txtLocation.text = userModel.ManuallyLocation
        }
        showLocainPopup(bool: false)
    }
    
    
    @IBAction func btnLocation(_ sender: UIButton) {
        
    }
    
    @IBAction func btnChangeLocation(_ sender: UIButton) {
        isSearch = true
        txtLocation.text = ""
        self.userModel.ManuallyLocation = ""
        // self.getcurrentLatlong()
        self.getUserLocation()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.getLsting()
        }
        
    }
    
    @objc func tapLocationView(sender:UITapGestureRecognizer) {
        showLocainPopup(bool: true)
        
    }
    
    func showLocainPopup(bool:Bool){
        UIView.transition(with: locationPopup, duration: 1.0,
                          options: .showHideTransitionViews,
                          animations: {
                            self.locationPopup.isHidden = bool
                          })
    }
    
    
    func getLsting()
    {
        self.showHud()
        isSearch = false
        
        //        if appDel.JobType == "JobFeed" {
        //         methodName = "MyJob?UserId=\(appDel.user_ID)"
        //        }
        self.data  = []
        if  appDel.JobType == "MyListing" {
            getMyListing()
        }
        if  appDel.JobType == "JobFeed" {
            getJobFeed()
            
        }
        
        
        
    }
    
    func getJobFeed() {
        let minprice:String  = Utilities.getUserDefault(KeyToReturnValye: "minprice") as? String ?? ""
        let maxprice:String = Utilities.getUserDefault(KeyToReturnValye: "maxprice") as? String ?? ""
        let category:String = Utilities.getUserDefault(KeyToReturnValye: "category") as? String ?? ""
        let methodName = "MyJob"
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "UserId":appDel.user_ID,
            "radius":40233.6,
            "Latitude":self.userModel.currantlat ?? 00,
            "Longitude":self.userModel.currantlong ?? 00,
            "Category":category,
            "minprice":minprice,
            "maxprice":maxprice,
            "show": CommonFunctions.isSwitch ?? "true",
            "showactive": CommonFunctions.isSwitchActive ?? "false"
        ]
        print(param)
        apiController.getRequest(methodName: methodName, param: param, isHUD: false) { (responce) in
            if responce["message"].stringValue == "success" {
                self.data = responce["data"].arrayValue
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    self.hideHud()
                    if self.data.count == 0 {
                        self.hideLabel(text: "No Jobs Found.", bool: false)
                    }
                    else{
                        self.hideLabel(text: "", bool: true)
                    }
                }
            }else{
                self.hideHud()
            }
            
        }
    }
    
    func getMyListing() {
        let methodName = "MyListing"
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "UserId":appDel.user_ID
        ]
        apiController.getRequest(methodName: methodName, param: param, isHUD: false) { (responce) in
            if responce["message"].stringValue == "success" {
                self.data = responce["data"].arrayValue
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    self.hideHud()
                    if self.data.count == 0 {
                        self.hideLabel(text: "No Jobs Found.", bool: false)
                    }
                    else{
                        self.hideLabel(text: "", bool: true)
                    }
                }
            }else{
                self.hideHud()
            }
            
        }
    }
    
    
    func getJobCategory(){
        let apiController : APIController = APIController()
        
        apiController.getRequest(methodName: "GetJobCategory", param:nil , isHUD: false) { (responce) in
            if responce["data"].arrayValue.count > 0{
                self.userModel.CategoryArr =  responce["data"].arrayValue.map { $0["CategoryName"].stringValue }
            }
        }
    }
    
    func getUserProfile(){
        
        if appDel.user_ID == 0 {
            return
        }
        
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "UserId":appDel.user_ID
        ]
        apiController.getRequest(methodName: "GetProfile",param: param, isHUD: false) { (responce) in
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
                self.userModel.UserRatingAvg = responce["data"]["UserRatingAvg"].doubleValue
                self.userModel.JobTypeCategory =  responce["data"]["JobType"].stringValue
                self.userModel.Balance = responce["data"]["Balance"].intValue
                self.userModel.RefCode = responce["data"]["RefCode"].stringValue
                self.userModel.accountNumber = responce["data"]["StripeAccId"].stringValue
                self.userModel.receivedAmount = responce["data"]["receivedAmount"].doubleValue
                self.userModel.azzidaVerified = responce["data"]["AzzidaVerified"].boolValue
                self.userModel.stripeAccId = responce["data"]["StripeAccId"].stringValue
                self.userModel.nationalStatus = responce["data"]["NationalStatus"].stringValue
                self.userModel.globalStatus = responce["data"]["GlobalStatus"].stringValue
                self.userModel.sexOffenderStatus = responce["data"]["SexOffenderStatus"].stringValue
                self.userModel.ssnTraceStatus = responce["data"]["SsnTraceStatus"].stringValue
                self.userModel.provider = responce["data"]["Provider"].stringValue
                self.userModel.candidateId = responce["data"]["CandidateId"].stringValue
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }
    
    private func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn, .viewSlideOutMenuPartialIn, .viewSlideOutMenuOut, .viewSlideOutMenuPartialOut, .viewSlideOutMenuZoom]
        return modes[0]
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.backgroundColor = constant.theamColor
        presentationStyle.onTopShadowColor = .black
        presentationStyle.onTopShadowOpacity = 0.8
        presentationStyle.onTopShadowRadius = 20
        //        presentationStyle.presentingScaleFactor = 0.5
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(view.frame.width, view.frame.height) * CGFloat(0.82276654)
        return settings
    }
    
    
    @IBAction func btnAddJob(_ sender: UIButton) {
        if appDel.user_ID == 0 {
            checkLogin.MovoToLogin(viewController: self)
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddJobViewController") as! AddJobViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnFilter(_ sender: UIButton) {
        // self.present(vc, animated: true, completion: nil)
        showFilter()
    }
    
    func showFilter(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        vc.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.linear)
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
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
    
    
    @IBAction func txtLocationTap(_ sender: UITextField) {
        txtLocation.resignFirstResponder()
        GMSAutocompleteVC.delegate = self
        present(GMSAutocompleteVC, animated: true, completion: nil)
    }
    
    
}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobTableViewCell", for: indexPath) as! JobTableViewCell
        cell.lblTitle.text = self.data[indexPath.row]["JobTitle"].stringValue
        cell.lblPrice.text = "$ \(data[indexPath.row]["Amount"].stringValue)"
        //--------------------------------Updating Code----------------------------------
        //        cell.imgIcon.downloadImage(url: data[indexPath.row]["ProfilePicture"].stringValue)
        cell.imgIcon.sd_setImage(with: URL(string: data[indexPath.row]["ProfilePicture"].stringValue), placeholderImage: UIImage(named: "no_profile"))
        //cell.imgIcon.downloadImage(url: userModel.ProfilePicture)
        
        print(data[indexPath.row]["Status"].stringValue)
        cell.lblJobStatus.text = data[indexPath.row]["Status"].stringValue
        
        
//        if data[indexPath.row]["Status"].stringValue == "Inprogress"{
//
//            //            tableView.allowsSelection = false
//            cell.lblJobStatus.textColor = .black
//            if #available(iOS 13.0, *) {
//                cell.roundView.backgroundColor = .systemGray5
//            } else {
//                cell.roundView.backgroundColor = .systemGray
//            }
//        }
         if data[indexPath.row]["Status"].stringValue == "Active" {
            cell.lblJobStatus.textColor = #colorLiteral(red: 0.462745098, green: 0.7882352941, blue: 0.6980392157, alpha: 1)
            
                cell.roundView.backgroundColor = .white
        }
         else{
            cell.lblJobStatus.textColor = #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
                cell.roundView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
         }
         
//        else if data[indexPath.row]["Status"].stringValue == "Completed" {
////            cell.lblJobStatus.text = data[indexPath.row]["Status"].stringValue
//            cell.lblJobStatus.textColor = .black
//            if #available(iOS 13.0, *) {
//                cell.roundView.backgroundColor = .systemGray5
//            } else {
//                cell.roundView.backgroundColor = .systemGray
//            }
//            //            tableView.allowsSelection = false
//        }
//
        
        
        cell.viewDotColor = data[indexPath.row]["Status"].stringValue
        print(data[indexPath.row]["FromDate"].doubleValue)
        cell.btnDate.setTitle(CommonStrings.getActivityDate(timeStamp: data[indexPath.row]["FromDate"].doubleValue), for: .normal)
        
        cell.btnDistance.setTitle(Distance.getDistance(lat1: self.currantlat ?? 00, lon1: self.currantlong ?? 00, lat2: data[indexPath.row]["Latitude"].doubleValue, lon2: data[indexPath.row]["Longitude"].doubleValue), for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        userModel.UserMainActivity = "HomeViewController"
        if data[indexPath.row]["Status"].stringValue == "Active"{
            
            if data[indexPath.row]["UserId"].intValue == appDel.user_ID{
                let vc = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                vc.jobID = data[indexPath.row]["Id"].intValue
                vc.currantlat = self.currantlat
                vc.currantlong = self.currantlong
                vc.titleStr = "Feed"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let vc = SecondStoryboard.instantiateViewController(withIdentifier: "MyJobFeedViewController") as! MyJobFeedViewController
                vc.listJSON = data[indexPath.row]
                vc.jobID = data[indexPath.row]["Id"].intValue
                vc.currantlat = self.currantlat
                vc.currantlong = self.currantlong
                vc.titleStr = "Feed"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension HomeViewController : JobFilterDelegate{
    func applyFilter(distance: String, Maxprice: String, MinPrice: String, category: String) {
        //appDel.JobType = "MyJobs"
        
        appDel.JobType = "JobFeed"
        self.initButton()
        if distance == "ClearFilter"{
            self.data  = []
            showHud()
            let apiController : APIController = APIController()
            let param:[String:Any] = [
                "UserId":appDel.user_ID,
                "radius":40233.6,
                "Latitude":self.userModel.currantlat ?? 00,
                "Longitude":self.userModel.currantlong ?? 00,
                "Category":category,
                "minprice":MinPrice,
                "maxprice":Maxprice,
                "show": CommonFunctions.isSwitch ?? "true",
                "showactive": CommonFunctions.isSwitchActive ?? "false"
            ]
            print(param)
            apiController.getRequest(methodName: "MyJob",param: param, isHUD: false) { (responce) in
                if responce["message"].stringValue == "success" {
                    self.data = responce["data"].arrayValue
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                        self.hideHud()
                        if self.data.count == 0 {
                            self.hideLabel(text: "No Jobs Found.", bool: false)
                        }
                        else{
                            self.hideLabel(text: "", bool: true)
                        }
                    }
                }else{
                    self.hideHud()
                }
                
            }
        }
        
        else{
            showHud()
            let apiController : APIController = APIController()
            let param:[String:Any] = [
                "UserId":appDel.user_ID,
                "Category":category,
                "radius":distance,
                "latitude":self.userModel.currantlat ?? 00,
                "longitude":self.userModel.currantlong ?? 00,
                "minprice":MinPrice,
                "maxprice":Maxprice,
                "show": CommonFunctions.isSwitch ?? "true",
                "showactive": CommonFunctions.isSwitchActive ?? "false"
            ]
            apiController.getRequest(methodName: "JobSearch", param: param, isHUD: false) { (responce) in
                if responce["message"].stringValue == "success" {
                    self.hideHud()
                    self.data = responce["data"].arrayValue
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                        if self.data.count == 0 {
                            self.hideLabel(text: "No jobs found using these filters.\n Please modify your filter selections.", bool: false)
                        }
                        else{
                            self.hideLabel(text: "", bool: true)
                        }
                    }}else{
                        self.hideHud()
                    }
            }
        }
    }
    
}


extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("formattedAddress",place.formattedAddress ?? "")
        
        DispatchQueue.main.async {
            self.ManuallyLocationPopup(place: place)
        }
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
                
                self.userModel.currantlat = place.coordinate.latitude
                self.userModel.currantlong = place.coordinate.longitude
                // self.currantlat = place.coordinate.latitude
                //self.currantlong = place.coordinate.longitude
                self.txtLocation.text = place.formattedAddress
                self.userModel.ManuallyLocation = place.formattedAddress ?? ""
                
                // self.googleAPIForAddress(late: place.coordinate.latitude, long: place.coordinate.longitude)
                self.getAddress(late: place.coordinate.latitude, long: place.coordinate.longitude)
                self.UpdateUserLatLong(late: place.coordinate.latitude, long: place.coordinate.longitude)
                self.GMSAutocompleteVC.dismiss(animated: true, completion: nil)
                self.showLocainPopup(bool: true)
                self.getLsting()
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        ServiceManager.topMostController().present(refreshAlert, animated: true, completion: nil)
        
    }
}





//
//  FilterViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 29/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

protocol JobFilterDelegate {
    func applyFilter(distance:String,Maxprice:String,MinPrice:String,category:String)
}


import UIKit
import CoreLocation
import GooglePlaces



class FilterViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var showActiveSwitch: UISwitch!
    @IBOutlet weak var sliderPrice: UISlider!
    @IBOutlet weak var sliderDistance: UISlider!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblCaregoies: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lbltoDistance: UILabel!
    @IBOutlet weak var lblFromDistance: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnClearFilter: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var hight: NSLayoutConstraint!
    @IBOutlet weak var GrayView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtMax: UITextField!
    @IBOutlet weak var txtMin: UITextField!
    @IBOutlet weak var switchShowHide: UISwitch!
    
    
    let userModel : UserModel = UserModel.userModel
    lazy var filterArr : [String] = []
    let Constant : CommonStrings = CommonStrings.commonStrings
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var delegate : JobFilterDelegate! = nil
    var selectCategory = ""
    var currantlat: CLLocationDegrees!
    var currantlong:CLLocationDegrees!
    var FilterRequest = ""
    var FilterCateArr : [String] = []
    var timerForShowScrollIndicator: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        TitleStr()
        //   getcurrentLatlong()
        
        filterArr = self.userModel.CategoryArr
        setFilter()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeTab))
        self.GrayView.isUserInteractionEnabled = true
        self.GrayView.addGestureRecognizer(tap)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)
        
        txtMin.changePlaceHolderWithColor(text: "Min", color: UIColor.black)
        txtMax.changePlaceHolderWithColor(text: "Max", color: UIColor.black)
        txtMin.keyboardType = .numberPad
        txtMax.keyboardType = .numberPad
        
        let category:String = Utilities.getUserDefault(KeyToReturnValye: "category") as? String ?? ""
        let minprice:String = Utilities.getUserDefault(KeyToReturnValye: "minprice") as? String ?? ""
        let maxprice:String = Utilities.getUserDefault(KeyToReturnValye: "maxprice") as? String ?? ""
        let km:Int = Utilities.getUserDefault(KeyToReturnValye: "distance") as? Int ?? 25
        self.sliderDistance.value = Float(km)
        txtMax.text = maxprice
        txtMin.text = minprice
        //        userModel.FilterMaxPrice = maxprice
        //        userModel.FilterMinPrice = minprice
        if(category != "")
        {
            let catArray = category.components(separatedBy: ",")
            FilterCateArr = catArray
            //            userModel.FilterCategory = catArray
        }
        
        
        
        //--------------This is Updates Code-----------------------
        
        if traitCollection.userInterfaceStyle == .dark{
            
            lblTitle.textColor = .white
            txtMax.changePlaceHolderWithColor(text: "Max", color: .white)
            txtMax.layer.borderColor = UIColor.white.cgColor
            txtMin.changePlaceHolderWithColor(text: "Min", color: .white)
            txtMin.layer.borderColor = UIColor.white.cgColor
            
        }else{
            lblTitle.textColor = .black
            txtMax.changePlaceHolderWithColor(text: "Max", color: .black)
            txtMax.layer.borderColor = UIColor.black.cgColor
            txtMin.changePlaceHolderWithColor(text: "Min", color: .black)
            txtMin.layer.borderColor = UIColor.black.cgColor
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if CommonFunctions.isSwitch == nil{
            CommonFunctions.isSwitch = "true"
        }
        if CommonFunctions.isSwitchActive == nil{
            CommonFunctions.isSwitchActive = "false"
        }
        
        if CommonFunctions.isSwitch == "true" {
            switchShowHide.setOn(true, animated: true)
        }
        else {
            switchShowHide.setOn(false, animated: true)
        }
        
//        if CommonFunctions.isSwitchActive == "true" {
//            showActiveSwitch.setOn(true, animated: true)
//        }
//        else {
//            showActiveSwitch.setOn(false, animated: true)
//        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // self.hight.constant = self.tblView.contentSize.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // self.tblView.flashScrollIndicators()
        startTimerForShowScrollIndicator()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // stopTimerForShowScrollIndicator()
        
    }
    
    @objc func showScrollIndicatorsInContacts() {
        //  self.tblView.flashScrollIndicators()
        UIView.animate(withDuration: 0.001) {
            self.tblView.flashScrollIndicators()
        }
    }
    
    /// Start timer for always show scroll indicator in table view
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
    }
    
    /// Stop timer for always show scroll indicator in table view
    func stopTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator?.invalidate()
        self.timerForShowScrollIndicator = nil
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            self.dismiss(animated: true, completion: nil)
        }
    } //SideMenu
    
//    @IBAction func actionShowActiveSwitch(_ sender: Any) {
//        if (sender as AnyObject).isOn == true {
//            CommonFunctions.isSwitchActive = "true"
//            CommonFunctions.isSwitch = "false"
//            switchShowHide.setOn(false, animated: true)
//        }
//        else{
//            CommonFunctions.isSwitchActive = "false"
//        }
//
//    }
    
    @IBAction func actionShowHideSwitch(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            CommonFunctions.isSwitch = "true"
//            showActiveSwitch.setOn(false, animated: true)
            CommonFunctions.isSwitchActive = "false"
        }
        else{
            CommonFunctions.isSwitch = "false"
            CommonFunctions.isSwitchActive = "true"
        }
    }
    
    func setFilter(){
        //        if userModel.FilterPrice == 0 {
        //            //priceStr(price:25)
        //           // sliderPrice.value = Float(25)
        //
        //        }
        //        else{
        //          //  priceStr(price:userModel.FilterPrice)
        //          //  sliderPrice.value = Float(userModel.FilterPrice)
        //        }
        //
        txtMax.text = userModel.FilterMaxPrice
        txtMin.text = userModel.FilterMinPrice
        
        if userModel.FilterDistance == 0 {
            distanceStr(distance: 25)
            sliderDistance.value = Float(25)
            
            
        }else{
            distanceStr(distance: userModel.FilterDistance)
            sliderDistance.value = Float(userModel.FilterDistance)
        }
        
        
        var arr : [String] = []
        arr = userModel.FilterCategory.filter { $0.isEmpty }
        
        if userModel.FilterCategory.count == 0 {
            FilterCateArr = Array(repeating: "", count: self.filterArr.count)
            
        }else{
            FilterCateArr = userModel.FilterCategory
            //            if arr.count == 6 {
            //                FilterCateArr = userModel.FilterCategory
            //            }else
            //            {
            //                FilterCateArr = userModel.FilterCategory
            //
            //            }
        }
        let category:String = Utilities.getUserDefault(KeyToReturnValye: "category") as? String ?? ""
        let minprice:String = Utilities.getUserDefault(KeyToReturnValye: "minprice") as? String ?? ""
        let maxprice:String = Utilities.getUserDefault(KeyToReturnValye: "maxprice") as? String ?? ""
        let km:Int = Utilities.getUserDefault(KeyToReturnValye: "distance") as? Int ?? 25
        self.sliderDistance.value = Float(km)
        distanceStr(distance: km)
        txtMax.text = maxprice
        txtMin.text = minprice
        
        //        userModel.FilterMaxPrice = maxprice
        //        userModel.FilterMinPrice = minprice
        if(category != "")
        {
            let catArray = category.components(separatedBy: ",")
            FilterCateArr = catArray
            //            userModel.FilterCategory = catArray
        }
        
        self.tblView.reloadData()
        
    }
    
    func clearFiltr(){
        userModel.FilterPrice = 0
        userModel.FilterMaxPrice = ""
        userModel.FilterMinPrice = ""
        userModel.FilterDistance = 0
        userModel.FilterCategory = Array(repeating: "", count: self.filterArr.count)
        Utilities.setUserDefault(ObjectToSave: "" as Any, KeyToSave: "minprice")
        Utilities.setUserDefault(ObjectToSave: "" as Any, KeyToSave: "maxprice")
        Utilities.setUserDefault(ObjectToSave: "" as Any, KeyToSave: "category")
        Utilities.setUserDefault(ObjectToSave: 25, KeyToSave: "distance")
        distanceStr(distance: 25)
        CommonFunctions.isSwitch = "true"
        CommonFunctions.isSwitchActive = "false"
        self.setFilter()
    }
    
    
    @objc func closeTab(sender:UITapGestureRecognizer) {
        print("tap working")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func setText(){
        //filterArr = ["Cleaning".localized(),"Exercise".localized(),"Landscaping".localized(),"Lifting".localized(),"Packing_Organizing".localized(),"Technology".localized()]
        
        lblCaregoies.text = "Categories".localized()
        btnClearFilter.setTitle("Clear_Filters".localized(), for: .normal)
        btnApply.setTitle("Apply".localized(), for: .normal)
    }
    
    @IBAction func btnApply(_ sender: UIButton) {
        
        let KM : Int = Int(Double(sliderDistance.value) * 1609.34)
        
        userModel.FilterDistance = Int(Double(sliderDistance.value))
        // userModel.FilterPrice = Int(sliderPrice.value)
        userModel.FilterMaxPrice = txtMax.text ?? ""
        userModel.FilterMinPrice = txtMin.text ?? ""
        userModel.FilterCategory = FilterCateArr
        
        Utilities.setUserDefault(ObjectToSave: txtMin.text ?? "" as Any, KeyToSave: "minprice")
        Utilities.setUserDefault(ObjectToSave: txtMax.text ?? "" as Any, KeyToSave: "maxprice")
        
        Utilities.setUserDefault(ObjectToSave: Int(Double(sliderDistance.value)), KeyToSave: "distance")
        var arr : [String] = FilterCateArr
        arr = arr.filter { !$0.isEmpty }
        
        var Category = ""
        for ind in arr{
            Category = Category + "," + ind
        }
        
        Category = String(Category.dropFirst())
        print(Category)
        Utilities.setUserDefault(ObjectToSave: Category as Any, KeyToSave: "category")
        Utilities.setUserDefault(ObjectToSave: txtMax.text as Any, KeyToSave: "maxprice")
        Utilities.setUserDefault(ObjectToSave: txtMin.text as Any, KeyToSave: "minprice")
        
        delegate.applyFilter(distance: "\(KM)",Maxprice: txtMax.text ?? "",MinPrice: txtMin.text ?? "", category: Category)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnClearFilter(_ sender: UIButton) {
        clearFiltr()
        delegate.applyFilter(distance: "ClearFilter",Maxprice: "",MinPrice: "",category: "")
        self.dismiss(animated: true, completion: nil)
        
//        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sliderDistance(_ sender: UISlider) {
        print(Int(sender.value))
        distanceStr(distance: Int(sender.value))
        
    }
    
    @IBAction func sliderPrice(_ sender: UISlider) {
        print(Int(sender.value))
        priceStr(price:Int(sender.value))
        
    }
    
    func priceStr(price:Int){
        let Price = NSAttributedString(string:"Price".localized(),
                                       attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                   NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
        
        let space = NSAttributedString(string:" - ",
                                       attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                   NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
        
        let above = NSAttributedString(string:"above $\(price)",
                                       attributes:[NSAttributedString.Key.foregroundColor:  Constant.theamColor,
                                                   NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
        let combination = NSMutableAttributedString()
        combination.append(Price)
        combination.append(space)
        combination.append(above)
        lblPrice.attributedText = combination
    }
    
    func distanceStr(distance:Int){
        //--------------------------This is New Code----------
        if traitCollection.userInterfaceStyle == .dark{
            let Distance = NSAttributedString(string:"Distance".localized(),
                                              attributes:[NSAttributedString.Key.foregroundColor: UIColor.white,
                                                          NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
            
            let space = NSAttributedString(string:" - ",
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
            
            let miles = NSAttributedString(string:"within \(distance) miles ",
                                           attributes:[NSAttributedString.Key.foregroundColor:  Constant.theamColor,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
            let combination = NSMutableAttributedString()
            combination.append(Distance)
            combination.append(space)
            combination.append(miles)
            
            
            lblDistance.attributedText = combination
            
        }else{
            
            let Distance = NSAttributedString(string:"Distance".localized(),
                                              attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                          NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
            
            let space = NSAttributedString(string:" - ",
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
            
            let miles = NSAttributedString(string:"within \(distance) miles ",
                                           attributes:[NSAttributedString.Key.foregroundColor:  Constant.theamColor,
                                                       NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
            let combination = NSMutableAttributedString()
            combination.append(Distance)
            combination.append(space)
            combination.append(miles)
            
            
            lblDistance.attributedText = combination
            
        }
        
        
        
        
        
        
        
        
        
        
        
        //-------------------This is Old Code--------------
        //          let Distance = NSAttributedString(string:"Distance".localized(),
        //                                                      attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
        //                                                                  NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
        //
        //          let space = NSAttributedString(string:" - ",
        //                                                      attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
        //                                                                  NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
        //
        //          let miles = NSAttributedString(string:"within \(distance) miles ",
        //                                                      attributes:[NSAttributedString.Key.foregroundColor:  Constant.theamColor,
        //                                                                  NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any])
        //          let combination = NSMutableAttributedString()
        //          combination.append(Distance)
        //          combination.append(space)
        //          combination.append(miles)
        //
        //
        //          lblDistance.attributedText = combination
        
        
    }
    
    
    func TitleStr(){
        let Filter = NSAttributedString(string:"Filter".localized(),
                                        attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23) as Any])
        
        let spaceString = NSAttributedString(string:" ",
                                             attributes:[NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.9),
                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 23) as Any])
        
        
        let Job_Feeds = NSAttributedString(string:"Jobs_Feed".localized(),
                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.9),
                                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 23) as Any])
        
        
        let combination = NSMutableAttributedString()
        combination.append(Filter)
        combination.append(spaceString)
        combination.append(Job_Feeds)
        lblTitle.attributedText = combination
        
    }
    
}


extension FilterViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.lblFilter.text = filterArr[indexPath.row]
        if(FilterCateArr.contains(filterArr[indexPath.row]))
        {
            cell.iconFilter.image = #imageLiteral(resourceName: "Filter_checked")
        }
        else{
            cell.iconFilter.image = #imageLiteral(resourceName: "Filter_unchecked")
        }
        //#imageLiteral(resourceName: "Side-Navigaiton-Profile")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if FilterCateArr.contains(filterArr[indexPath.row]) {
            FilterCateArr = FilterCateArr.filter({$0 != filterArr[indexPath.row]})
        }
        else{
            FilterCateArr.append(filterArr[indexPath.row])
        }
        
        
        tableView.reloadData()
    }
    
    
}

class FilterCell: UITableViewCell {
    
    @IBOutlet weak var lblFilter : UILabel!
    @IBOutlet weak var iconFilter : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

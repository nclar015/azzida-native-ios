//
//  JobRePostViewController.swift
//  Azzida
//
//  Created by iVishnu on 04/08/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class JobRePostViewController: UIViewController,CalendarViewDelegate {
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var lblDoYouWAnt: UILabel!
//    @IBOutlet weak var lblDateTitle: UILabel!
//    @IBOutlet weak var txtDate: UITextField!
//    @IBOutlet weak var btnClose: UIButton!
//    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var ViewRePost: UIView!
    @IBOutlet weak var ViewPaymentmode: UIView!
    
//    var datePickerView:UIDatePicker = UIDatePicker()
    var dateInMillis : Double!
    var delegate : JobRepostDelegate! = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var JobID = 0
    var PopUpType = ""
     var dateValue : String!
    var dateValueFormate : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        txtDate.delegate = self
        
        if PopUpType == "MakePayment" {
            ViewPaymentmode.isHidden = false
            ViewRePost.isHidden = true
        }
        else{
            ViewPaymentmode.isHidden = true
            ViewRePost.isHidden = false
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeTab))
        self.view.isUserInteractionEnabled = true
//        self.view.addGestureRecognizer(tap)
        
        //----------------------------Updated Code------------------------
        
//        if traitCollection.userInterfaceStyle == .dark{
//            lblDoYouWAnt.textColor = UIColor.white
//            lblDateTitle.textColor = UIColor.white
//        }else{
//            lblDoYouWAnt.textColor = UIColor.black
//            lblDateTitle.textColor = UIColor.black
//
//
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ViewPaymentmode.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        ViewPaymentmode.clipsToBounds = true
    }
    
//    @objc func closeTab(sender:UITapGestureRecognizer) {
//        print("tap working")
//        self.dismiss(animated: true, completion: nil)
//
//    }

//    @IBAction func btnSubmit(_ sender: UIButton) {
//        if (txtDate.text!.isEmpty){
//            Alert.alert(message: "Please_select_From_Job_Date".localized(), title: "Alert")
//            return
//        }
//
//
//    }
    
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
        
        let interval = Date() - someDate!
        if interval.day! > 0 {
            CommonFunctions.showAlert(self, message: "Please don't use back date", title: appName)
        }
//        if someDate! < Date() {
//            CommonFunctions.showAlert(self, message: "Please don't use back date", title: appName)
//        }
        else{
        
        rePostApi()
//           txtDate.text = dateValue
//                      placeholderView.isHidden = true
        }
          }
    
    
    func rePostApi(){
        let apiController : APIController = APIController()
        self.dateInMillis = (self.miliSecFromDate(date: self.dateValue ?? "") as NSString).doubleValue + 84240000
        apiController.postRequest(methodName: "RePostJob?JobId=\(JobID)&UserId=\(appDelegate.user_ID)&FromDate=\(dateInMillis ?? 00)") { (responce) in
            if responce["message"].stringValue == "success" {
                DispatchQueue.main.async {
                    self.doneAlert(message: "Job RePost Successfully.")
                }
            }
        }
    }

    
    
    
    func doneAlert(message:String){
        let refreshAlert = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
            self.delegate.dismisViewController()
            // self.navigationController?.popToViewController(ofClass: HomeViewController.self)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
//    @IBAction func btnClose(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func btnPayWithNewCard(_ sender: UIButton) {
        let vc = Mainstoryboard.instantiateViewController(withIdentifier: "AddPaymentViewController") as! AddPaymentViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.PaymentType = "MakePayment"
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func btnPayWithExitingCard(_ sender: UIButton) {
//        let vc = Mainstoryboard.instantiateViewController(withIdentifier: "EditPaymentViewController") as! EditPaymentViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        self.dismiss(animated: true, completion: nil)
        self.delegate.dismisViewController()
    }

    
    func miliSecFromDate(date : String) -> String {
        let strTime = date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
         formatter.timeZone = .autoupdatingCurrent
        let ObjDate = formatter.date(from: strTime)
        return (String(describing: ObjDate!.millisecondsSince1970))
    }
    
}

//extension JobRePostViewController : UITextFieldDelegate{
//        
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == txtDate{
//            self.pickUpDate(textField)
//        }
//    }
//    
//    
//    func pickUpDate(_ textField : UITextField){
//        datePickerView.datePickerMode = UIDatePicker.Mode.date
//        datePickerView.minuteInterval = 15
//        datePickerView.minimumDate = NSDate() as Date
//        // datePickerView = datePickerView
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddJobViewController.doneTapped))
//        toolBar.setItems([spaceButton, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        if #available(iOS 13.4, *) {
////            datePickerView.preferredDatePickerStyle = .wheels
//        }
//        self.txtDate.inputView = datePickerView
//        self.txtDate.inputAccessoryView = toolBar
//        datePickerView.addTarget(self, action: #selector(AddJobViewController.datePickerValueChanged(_:)), for: .valueChanged)
//        
//    }
//    
//    @objc func doneTapped() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "MM-dd-yyyy"
//        self.txtDate.text = dateFormatter.string(from: datePickerView.date)
//        dateInMillis = datePickerView.date.millisecondsSince1970
//        self.txtDate.resignFirstResponder()
//    }
//    
//    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "MM-dd-yyyy"
//        self.txtDate.text = dateFormatter.string(from: sender.date)
//        dateInMillis = datePickerView.date.millisecondsSince1970
//        _ = dateFormatter.string(from: sender.date)
//    }
//       
//}


protocol JobRepostDelegate {
    func dismisViewController()
}

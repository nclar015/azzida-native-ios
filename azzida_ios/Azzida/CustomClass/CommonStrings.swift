//
//  CommonStrings.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 27/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import Foundation
import UIKit

class CommonStrings : NSObject{
    
    let theamGreenColor = UIColor(displayP3Red: 70/255, green: 176/255, blue: 137/255, alpha: 1.0)
    let theamBlueColor = UIColor(displayP3Red: 24/255, green: 139/255, blue: 255/255, alpha: 1.0)
    let theamColor = UIColor(displayP3Red: 47/255, green: 97/255, blue: 173/255, alpha: 1.0)
   
    let appImageBaseUrl = "http://13.72.77.167:8086/ApplicationImages/"
    let googleAPIKey = "AIzaSyCmjsvbSYhpc2tu9QluKnnaS5Ro0Ykcv14"
  
    
    static  let commonStrings : CommonStrings = CommonStrings()
        
    
    //defaultServiceKey
       class func setUserDefalut(_ value :AnyObject ,key :String){
           UserDefaults.standard.set(value, forKey: key)
           UserDefaults.standard.synchronize()
       }
    
    
    class func getDateFromTimeStamp(timeStamp : Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: Double(timeStamp) / 1000)
        let formatter = DateFormatter()
       // formatter.numberStyle = .ordinal

        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        // formatter.timeZone = TimeZone.current
        formatter.dateFormat =  "E, d MMM yyyy"
        return (formatter.string(from: date as Date))
    }
    
    class func getFromatedDate(timeStamp : Double) -> String {
           
           let date = NSDate(timeIntervalSince1970: Double(timeStamp) / 1000)
           let formatter = DateFormatter()
          // formatter.numberStyle = .ordinal

           formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
           // formatter.timeZone = TimeZone.current
           formatter.dateFormat =  "MM/dd/yyyy"
           return (formatter.string(from: date as Date))
       }
    
    class func getJobListDate(timeStamp : Double) -> String {
              
              let date = NSDate(timeIntervalSince1970: Double(timeStamp) / 1000)
              let formatter = DateFormatter()
             // formatter.numberStyle = .ordinal

              formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
              // formatter.timeZone = TimeZone.current
              formatter.dateFormat =  "MM/dd/yyyy"
              return (formatter.string(from: date as Date))
          }
    
    class func getActivityDate(timeStamp : Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: Double(timeStamp) / 1000)
        let formatter = DateFormatter()
       // formatter.numberStyle = .ordinal

        //formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
         formatter.timeZone = TimeZone.current
        formatter.dateFormat =  "MM/dd/yyyy"
        return (formatter.string(from: date as Date))
    }
    
    
    class func ordinalDateFormate(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "E,MMM, d"
        let newDate = dateFormate.string(from: date as Date)

        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return newDate + day
    }


}

let SecondStoryboard: UIStoryboard = UIStoryboard(name: "Secondary", bundle: nil)
let Mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)


class checkLogin: NSObject
{
    class func MovoToLogin(viewController:UIViewController){
        let refreshAlert = UIAlertController(title: "Login Required", message: "", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
//            let navigationController = viewController.presentingViewController as? UINavigationController
//
//            viewController.dismiss(animated: true) {
//                let _ = navigationController?.popToRootViewController(animated: true)
//            }
            let _ = viewController.navigationController?.popToRootViewController(animated: true)

        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        viewController.present(refreshAlert, animated: true, completion: nil)
        

    }
    
    class func MovoToLoginFromSideMenu(viewController:UIViewController){
            let refreshAlert = UIAlertController(title: "Login Required", message: "", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                let navigationController = viewController.presentingViewController as? UINavigationController
    
                viewController.dismiss(animated: true) {
                    let _ = navigationController?.popToRootViewController(animated: true)
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            viewController.present(refreshAlert, animated: true, completion: nil)
            

        }
}


extension UITextView{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

//
//  CommonFunctions.swift
//  Azzida
//
//  Created by Varun Naharia on 07/04/21.
//  Copyright © 2021 Vishnu Chhipa. All rights reserved.
//
import UIKit

class CommonFunctions: NSObject {
    
    
    
    static var isEmailApple:String?{
        set {
            UserDefaults.standard.setValue(newValue, forKey: isEmail)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: isEmail)
        }
    }
    class func showAlert(_ reference:UIViewController, message:String, title:String){
        var alert = UIAlertController()
        if title == "" {
            alert = UIAlertController(title: nil, message: message,preferredStyle: .alert)
        }
        else{
            alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        reference.present(alert, animated: true, completion: nil)
        
    }
    
    static var isNameApple:String?{
        set {
            UserDefaults.standard.setValue(newValue, forKey: isName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: isName)
        }
    }
    static var isSwitch:String?{
        set {
            UserDefaults.standard.setValue(newValue, forKey: isSwitchHide)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: isSwitchHide)
        }
    }
    static var isSwitchActive:String?{
        set {
            UserDefaults.standard.setValue(newValue, forKey: switchActive)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: switchActive)
        }
    }
}
extension Date {
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
}

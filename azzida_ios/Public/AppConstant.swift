
//
//  AppConstant.swift
//  B24
//
//  Created by Varun Naharia on 21/08/17.
//  Copyright © 2017 Logictrixtech. All rights reserved.
//


import Foundation
import UIKit
import CoreBluetooth


class AppConstant {
    

    public static var appName = "Azzida"
    
    
    static func multilineTitle(title:String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.text = title
        label.textColor = .white
        return label
    }
}


struct AppMessage {
    static let MSGNoInternet = "No Internet"
}

struct AppColor {
    static let Color_Blue = UIColor.blue
    static let Color_Black = UIColor.black
    static let Color_White = UIColor.white
    static let Color_Green = UIColor.green
    static let Color_Yellow = UIColor(red: 0.78, green: 0.67, blue: 0.15, alpha: 1.00)
}

//struct AppURL {
//    #if DEVELOPMENT
//        static let BaseURL = "http://13.72.77.167:8086/api/"
//    #else
//        static let BaseURL = "http://13.72.77.167:8086/api/"
//    #endif
//
//}

struct AppURL {
    #if DEVELOPMENT
    static let BaseURL = "http://13.72.77.167:8088/api/"
    #else
    static let BaseURL = "http://13.72.77.167:8088/api/"
    #endif

}

struct AppTokenUsed {
//    static let tokenUsed = "live"
    static let tokenUsed = "test"
}




struct AppTheme {
    
    func customizeAppTheme() -> Void {
        var navigationBarAppearace = UINavigationBar.appearance()
        #if DEVELOPMENT
            // set navigation colors, view colors for development app
            navigationBarAppearace.barTintColor = AppColor.Color_Blue
            navigationBarAppearace.tintColor = AppColor.Color_White
            navigationBarAppearace.isTranslucent = false
            navigationBarAppearace.titleTextAttributes = [ NSFontAttributeName: UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.white];
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        #else
            // set navigation colors, view colors for live app
            navigationBarAppearace.barTintColor = AppColor.Color_Black
            navigationBarAppearace.tintColor = AppColor.Color_White
            navigationBarAppearace.isTranslucent = false
            navigationBarAppearace.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white];
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        #endif
        
    }
}

struct AppFont {
    
}


struct AppStoryboard {
    static let STORYBOARD_MAIN = UIStoryboard(name: "Main", bundle: Bundle.main)
}

struct AppPreferenceKey {
    static let kCurrentUser = "kCurrentUser"
}

struct AppViewTags {
    static let NoInternetViewTag = 2000
}

struct Constant {
    public static let appYellowColor:UIColor = UIColor(red: 0.78, green: 0.67, blue: 0.15, alpha: 1.00)
    public static let appDarkBlueColor:UIColor = UIColor(red: 0.02, green: 0.38, blue: 0.53, alpha: 1.00)
    public static let appDarkGreenColor:UIColor = UIColor(red: 0.25, green: 0.71, blue: 0.28, alpha: 1.00)
    public static let appLightGreenColor:UIColor = UIColor(red: 0.48, green: 0.93, blue: 0.24, alpha: 1.00)
    public static let appGrayColor:UIColor = UIColor(red: 0.93, green: 0.92, blue: 0.92, alpha: 1.00)
}



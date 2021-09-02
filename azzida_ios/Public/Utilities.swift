//
//  Utilities.swift
//  RudyGrubFeeder
//
//  Created by Jaswant Panwar on 02/02/17.
//  Copyright © 2017 Logictrix. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase
import FirebaseDynamicLinks

private var _screenHeight = UIScreen.main.bounds.height
private var _screenSize = UIScreen.main.bounds
private var _screenWidth = UIScreen.main.bounds.width
private var _screenCenterX = UIScreen.main.bounds.width/2
private var _screenCenterY = UIScreen.main.bounds.height/2

enum AlertType {
    case popUp
    case topDown
}

class Utilities {
    
    public class var screenHeight: CGFloat
    {
        get { return _screenHeight }
        set { _screenHeight = newValue }
    }
    
    public class var screenSize: CGRect
    {
        get { return _screenSize }
        set { _screenSize = newValue }
    }
    
    public class var screenWidth: CGFloat
    {
        get { return _screenWidth }
        set { _screenWidth = newValue }
    }
    
    public class var screenCenterX: CGFloat
        {
        get { return _screenCenterX }
        set { _screenCenterX = newValue }
    }
    
    public class var screenCenterY: CGFloat
        {
        get { return _screenCenterY }
        set { _screenCenterY = newValue }
    }
    
    class func getDateString(dateString:String, format:String?) -> String {
        var timestampString = dateString
        timestampString = timestampString.replacingOccurrences(of: "Date(", with: "")
        timestampString = timestampString.replacingOccurrences(of: ")", with: "")
        timestampString = timestampString.replacingOccurrences(of: "/", with: "")
        
        let date = timestampString != "" ? Date(timeIntervalSince1970: Double(timestampString)! / 1000.0) : Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format ?? "MM-dd-yyyy HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    class func getDateString(date:Date, format:String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format ?? "MM-dd-yyyy HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
//    class func getDateString(date:Date) -> String {
//        let strDate = "\(date.timeIntervalSince1970)"
//        return strDate
//    }
    
    class func getDate(dateString:String, format:String?) -> Date {
        var timestampString = dateString
        if(dateString != "")
        {
            
            timestampString = timestampString.replacingOccurrences(of: "Date(", with: "")
            timestampString = timestampString.replacingOccurrences(of: ")", with: "")
            timestampString = timestampString.replacingOccurrences(of: "/", with: "")
        }
        else
        {
            timestampString = "\(Date().millisecondsSince1970)"
        }
            let date = Date(timeIntervalSince1970: Double(timestampString)! / 1000.0)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = format ?? "MM-dd-yyyy HH:mm"
            let dateStr = dateFormatter.string(from: date)
            return dateFormatter.date(from: dateStr)!
        
    }
    
    class func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as String
    }
    
    
    class func stringTimeToTimeinterval(stringTime:String) -> TimeInterval {
        let sepratedTimeArray = stringTime.components(separatedBy: ":")
        let hour = UInt64(Double(sepratedTimeArray[0])! / 3600.0)
        
        let minutes = UInt64(Double(sepratedTimeArray[1])! / 60.0)
        
        let seconds = UInt64(Double(sepratedTimeArray[2])!)
        
        return TimeInterval(exactly: hour+minutes+seconds)!
    }
    
    public class func getAddressFrom(location: CLLocation, completion:@escaping ((String?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if(placemarks != nil && (placemarks?.count)! > 0)
            {
                let placemark:CLPlacemark = (placemarks?.first)!
                //let subThoroughfare:String? = (placemark.subThoroughfare)!
                //let thoroughfare:String? = (placemark.thoroughfare)!
                let name:String = placemark.name != nil ? placemark.name!:""
                let locality:String = placemark.locality != nil ? placemark.locality!:""
                let administrativeArea:String = placemark.administrativeArea != nil ? placemark.administrativeArea!:""
                let country:String = placemark.country != nil ? placemark.country!:""
                let pin:String = placemark.postalCode != nil ? placemark.postalCode!:""
                let address = "\(name), \(locality) \(administrativeArea), \(country), \(pin)"
                completion(address)
            }
            else
            {
                completion(nil)
            }
            //            if let placemark = placemarks?.first,
            //                let locality = placemark.locality,
            //                let administrativeArea = placemark.administrativeArea {
            //                let address = locality + " " + administrativeArea
            //
            //                //placemark.addressDictionary
            //                print("addressmax:\(address)")
            //                completion(address)
            //
            //            }
            //            else
            //            {
            //                completion(nil)
            //            }
        }
        //***************************************************************
        //        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
        ////        let apikey = "AIzaSyAUY2IpJpM2XW1-pxrzapIs24WDWj3jzWc"
        //        let url = "\(baseUrl)latlng=\(location.coordinate.latitude),\(location.coordinate.longitude)"
        //        ServiceManager.requestWithGet(baseURL: url, methodName: "", parameter: nil, isHUD: false) { (response) in
        //            if let result = response["results"].arrayObject as? [[String:Any]] {
        //                if result.count > 0 {
        //                    if let address = result[0]["address_components"] as? NSArray {
        //                        let number = (address[0] as! [String:Any])["short_name"] as! String
        //                        let street = (address[1] as! [String:Any])["short_name"] as! String
        //                        let city = (address[2] as! [String:Any])["short_name"] as! String
        //                        let state = (address[4] as! [String:Any])["short_name"] as! String
        //                        let zip = (address[6] as! [String:Any])["short_name"] as! String
        //                        print("\n\(number) \(street), \(city), \(state) \(zip)")
        //                        completion("\(number) \(street), \(city), \(state) \(zip)")
        //                    }
        //                }
        //            }
        //        }
        
    }

    public class func setStatusBarColor(color:UIColor, controller:UIViewController){
        let viewBG = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        viewBG.backgroundColor = color
        controller.navigationController?.view.addSubview(viewBG)
    }
    
    public class func setNavigationColor(controller:UIViewController, backgroundColor:UIColor, tintColor:UIColor, titleTextColor:UIColor, barStyle:UIBarStyle)
    {
        let nav = controller.navigationController?.navigationBar
        nav?.barStyle = barStyle
        nav?.tintColor = tintColor
        nav?.backgroundColor = backgroundColor //
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleTextColor]
    }
    
    class func setUserDefault(ObjectToSave : Any?  , KeyToSave : String)
    {
        let defaults = UserDefaults.standard
        
        if (ObjectToSave != nil)
        {
            
            defaults.set(ObjectToSave, forKey: KeyToSave)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    class func getUserDefault(KeyToReturnValye : String) -> Any?
    {
        let defaults = UserDefaults.standard
        
        if let name = defaults.value(forKey: KeyToReturnValye)
        {
            return name as Any
        }
        return nil
    }
    
    class func setCustomObjectToUserDefault(_ ObjectToSave : Any?  , KeyToSave : String) {
        let userDefaults = UserDefaults.standard
        do{
            let encodedData:Data = try NSKeyedArchiver.archivedData(withRootObject: ObjectToSave!, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: KeyToSave)
            userDefaults.synchronize()
        }
        catch
        {
            print(error)
        }
        
    }
    
    class func getCustomObjectToUserDefault( KeyToReturnValye : String) -> Any? {
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.object(forKey: KeyToReturnValye) as? Data
        if(decoded != nil)
        {
            do{
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!)
            }
            catch
            {
                print(error)
                return nil
            }
        }else
        {
            return nil
        }
    }
    
    
    
    class func removetUserDefault(KeyToRemove : String)
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: KeyToRemove)
        UserDefaults.standard.synchronize()
    }
    
    class func topMostController() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    class func alert(message:String){
        let alert=UIAlertController(title: AppConstant.appName, message: message, preferredStyle: .alert);
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            
        }
        alert.addAction(cancelAction)
        Utilities.topMostController().present(alert, animated: true, completion: nil);
    }
    
    class func alert(message:String, doneAction:@escaping ((String?) -> Void)){
        let alert=UIAlertController(title: AppConstant.appName, message: message, preferredStyle: .alert);
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            doneAction("")
        }
        alert.addAction(cancelAction)
        Utilities.topMostController().present(alert, animated: true, completion: nil);
    }
    
    static var alertBackgroundColour:UIColor = UIColor.white
    static var alertLabelColour:UIColor = UIColor.black
    static var alertImage:UIImage = #imageLiteral(resourceName: "alert")
    class func alert(_ message:String, alertType:AlertType = .popUp){
        if(alertType == .popUp)
        {
            let alert=UIAlertController(title: AppConstant.appName, message: message, preferredStyle: .alert);
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
                
            }
            alert.addAction(cancelAction)
            Utilities.topMostController().present(alert, animated: true, completion: nil);
        }
        else if(alertType == .topDown)
        {
            let viewContainer:UIView = UIView()
            viewContainer.backgroundColor = alertBackgroundColour
            
            let imageView:UIImageView = UIImageView()
            imageView.image = alertImage
            viewContainer.addSubview(imageView)
            
            let labelContent:UILabel = UILabel()
            labelContent.text = message
            labelContent.lineBreakMode = .byWordWrapping
            labelContent.numberOfLines = 0
            viewContainer.addSubview(labelContent)
            Utilities.topMostController().view.addSubview(viewContainer)
            
            viewContainer.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint = NSLayoutConstraint(item: viewContainer, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContainer.superview!, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: viewContainer, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContainer.superview!, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: viewContainer, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContainer.superview!, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
            let heightConstraint = NSLayoutConstraint(item: viewContainer, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
            NSLayoutConstraint.activate([ topConstraint, leadingConstraint, trailingConstraint,  heightConstraint])
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            let topConstraintImage = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContainer, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 25)
            let leadingConstraintImage = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContainer, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 8)
            let widthConstraintImage = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 20)
            let heightConstraintImage = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 20)
            NSLayoutConstraint.activate([ topConstraintImage, leadingConstraintImage, widthConstraintImage,  heightConstraintImage])
            
            labelContent.translatesAutoresizingMaskIntoConstraints = false
            let topConstraintLabel = NSLayoutConstraint(item: labelContent, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContainer, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 21)
            let leadingConstraintLabel = NSLayoutConstraint(item: labelContent, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imageView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 8)
            let trailingConstraintLabel = NSLayoutConstraint(item: labelContent, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem:viewContainer, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 8)
            let bottomConstraintLabel = NSLayoutConstraint(item: labelContent, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContainer, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: 8)
            NSLayoutConstraint.activate([ topConstraintLabel, leadingConstraintLabel, trailingConstraintLabel,  bottomConstraintLabel])
            
            viewContainer.layoutSubviews()
            
            viewContainer.center.y -= 50
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn], animations: {
                viewContainer.center.y += 50
            }) { (finished) in
                if(finished)
                {
                    UIView.animate(withDuration: 1.0, delay: 4.0, options: [.curveEaseOut], animations: {
                        viewContainer.center.y -= viewContainer.frame.size.height
                    }, completion: { (completed) in
                        if(completed)
                        {
                            viewContainer.removeFromSuperview()
                        }
                    })
                }
            }
            
        }
    }
    
    
    class func addUnderlineTo(textField:UITextField, lineColor:UIColor) {
        let titleUnderLine = UIView()
        titleUnderLine.backgroundColor = lineColor
        textField.addSubview(titleUnderLine)
        self.setUnderLineConstraint(lineView: titleUnderLine, lineSuperView: textField)
    }
    
    class func addDownArrowToTextField(arrowImage:UIImage, textField:UITextField) {
        let imageView:UIImageView = UIImageView(image: arrowImage)
        textField.addSubview(imageView)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        addDownArrowConstraint(arrowImageView: imageView, textField: textField)
    }
    class func addDownArrowConstraint(arrowImageView:UIImageView, textField:UITextField) {
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        let centerYConstraint = NSLayoutConstraint(item: arrowImageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: textField, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: arrowImageView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: textField, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: arrowImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 20)
        let widthConstraint = NSLayoutConstraint(item: arrowImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 20)
        NSLayoutConstraint.activate([ centerYConstraint, trailingConstraint,  heightConstraint, widthConstraint])
    }
    class func setUnderLineConstraint(lineView:UIView, lineSuperView:UIView) {
        lineView.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: lineView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: lineSuperView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: lineView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: lineSuperView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: lineView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: lineSuperView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: lineView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 1)
        NSLayoutConstraint.activate([ bottomConstraint, leadingConstraint, trailingConstraint,  heightConstraint])
    }
    
    class func isValidEmail(email:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    class func createShareLink(jobid:String, image:String?, onComplete:@escaping (_ url:URL) -> Void)  {
        guard let link = URL(string: "https://azzidaapp.page.link?JobId=\(jobid)") else { return }
        print(link)
        let dynamicLinksDomainURIPrefix = "https://azzidaapp.page.link"
        guard let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix) else { return}
        print(linkBuilder)
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.Azzida")
        linkBuilder.iOSParameters!.appStoreID = "1534894647"
        linkBuilder.iOSParameters!.minimumAppVersion = "1.0"
        
        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.azzida")
        linkBuilder.androidParameters!.minimumVersion = 1
//        linkBuilder.analyticsParameters = DynamicLinkGoogleAnalyticsParameters(source: "orkut",
//                                                                               medium: "social",
//                                                                               campaign: "example-promo")
        
//        linkBuilder.iTunesConnectParameters = DynamicLinkItunesConnectAnalyticsParameters()
//        linkBuilder.iTunesConnectParameters!.providerToken = "123456"
//        linkBuilder.iTunesConnectParameters!.campaignToken = "example-promo"
        
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters!.title = "Azzida"
        linkBuilder.socialMetaTagParameters!.descriptionText = "\nLet me recommend you this Job\n\n"
        if(image != "")
        {
            linkBuilder.socialMetaTagParameters!.imageURL = URL(string: image!)
        }
        
        let newURL:URL = URL(string: "\(linkBuilder.url!.absoluteString)&ofl=http://azzida.com")!
        print(newURL)
        DynamicLinkComponents.shortenURL(newURL, options: nil) { url, warnings, error in
            print(url)
            guard let url = url else { return }
            print("The short URL is: \(url)")
            onComplete(url)
        }
        
//        linkBuilder.shorten(completion: { (url, warnning, error) in
//            print("url:\(String(describing: url))")
//            print("warnning:\(String(describing: warnning))")
//            print("error:\(String(describing: error))")
//            guard let url = url, error == nil else
//            {
//                return
//
//            }
//            print("The short URL is: \(url)")
//            onComplete(url)
//        })
        
    }
}

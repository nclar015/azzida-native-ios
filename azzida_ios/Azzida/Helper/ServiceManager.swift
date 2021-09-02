//
//  ServiceManager.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 12/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import Alamofire
import Compression

class ServiceManager: NSObject,MBProgressHUDDelegate {
    
    
    
    class func requestWithGet(methodName:String,hudMsg:String,parameter:[String:Any]?,isHUD:Bool ,successHandler: @escaping (_ success:JSON) -> Void) {
        let errorDict:[String:Any] = [:]
        var errorJson:JSON = JSON(errorDict)
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json"]
        
        if ReachabilityCheck.sharedInstance.isInternetAvailable(){
            
            var topVC:UIViewController!
            var HUD:MBProgressHUD!
            if(isHUD)
            {
                topVC = ServiceManager.topMostController()
                HUD = MBProgressHUD(view:topVC.view)
                HUD.color = UIColor(displayP3Red: 47/255, green: 97/255, blue: 173/255, alpha: 1.0)
                UIApplication.topViewController()?.view.addSubview(HUD)
                HUD.mode = .indeterminate
                HUD.labelText = hudMsg
                HUD.show(true)
            }
            
            var jsonResponse:JSON!
            let urlString = AppURL.BaseURL.appending("\(methodName)")
            print("Request_url",urlString)
            Alamofire.request(urlString, method: .get, parameters:parameter, encoding: URLEncoding(destination: .queryString) ,headers: headers).responseJSON { (response:DataResponse<Any>) in
                switch response.result{
                case .failure(let error):
                    print(error)
                    errorJson = ["status":0,"message":"Network Failure"]
                    print(response.request ?? "nil")  // original URL request
                    
                    print(String(data: response.data!, encoding: .utf8)!)
                    print(response.result)   // result of response serialization
                    
                    successHandler(errorJson)
                    break
                case .success(let value):
                    print(value)
                    
                    let json = JSON(data: response.data!)
                    //                    print("\(json)")
                    jsonResponse = json
                    successHandler(jsonResponse)
                    break
                }
                if(isHUD)
                {
                    HUD.hide(true)
                    HUD.removeFromSuperview()
                    
                }
            }
        }
        else
        {
            errorJson = ["status":0,"message":"Network is Unreachable"]
            successHandler(errorJson)
            ServiceManager.alert(message: "Network is Unreachable")
        }
    }
    
    
    class func requestWithPost(methodName:String , parameter:[String:Any]?,isHUD:Bool,hudMsg:String,successHandler: @escaping (_ success:JSON) -> Void) {
        let errorDict:[String:Any] = [:]
        var errorJson:JSON = JSON(errorDict)
        
        if ReachabilityCheck.sharedInstance.isInternetAvailable(){
            // indicator.startAnimating()
            var topVC:UIViewController!
            var HUD:MBProgressHUD!
            if(isHUD)
            {
                topVC = ServiceManager.topMostController()
                HUD = MBProgressHUD(view:topVC.view)
                HUD.color = UIColor(displayP3Red: 47/255, green: 97/255, blue: 173/255, alpha: 1.0)
                UIApplication.topViewController()?.view.addSubview(HUD)
                HUD.mode = .indeterminate
                HUD.labelText = hudMsg
                HUD.show(true)
            }
            
            let parameters: Parameters = parameter!
            var jsonResponse:JSON!
            let urlString = AppURL.BaseURL.appending("\(methodName)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print(urlString ?? "")
            
            Alamofire.request(urlString!, method: .post,parameters: parameters, encoding: URLEncoding()).responseJSON { (response:DataResponse<Any>) in
                switch response.result{
                case .failure(let error):
                    print(error)
                    break
                case .success(let value):
                    print(value)
                    print(response.request!)  // original URL request
                    print(response.response!) // HTTP URL response
                    print(String(data: response.data!, encoding: .utf8)!)     // server data
                    print(response.result)   // result of response serialization
                    
                    let json = JSON(data: response.data!)
                    print("\(json)")
                    jsonResponse = json
                    successHandler(jsonResponse)
                    break
                }
                
                // indicator.stopAnimating()
                HUD.hide(true)
                HUD.removeFromSuperview()
            }
        }
        else
        {
            errorJson = ["status":0,"message":"Network is Unreachable"]
            successHandler(errorJson)
            ServiceManager.alert(message: "Network is Unreachable")
        }
    }
        
    class func requestWithPostQueryString(methodName:String , parameter:[String:Any]?,isHUD:Bool,hudMsg:String,successHandler: @escaping (_ success:JSON) -> Void) {
        let errorDict:[String:Any] = [:]
        var errorJson:JSON = JSON(errorDict)
        
        if ReachabilityCheck.sharedInstance.isInternetAvailable(){
            // indicator.startAnimating()
            var topVC:UIViewController!
            var HUD:MBProgressHUD!
            if(isHUD)
            {
                topVC = ServiceManager.topMostController()
                HUD = MBProgressHUD(view:topVC.view)
                HUD.color = UIColor(displayP3Red: 47/255, green: 97/255, blue: 173/255, alpha: 1.0)
                UIApplication.topViewController()?.view.addSubview(HUD)
                HUD.mode = .indeterminate
                HUD.labelText = hudMsg
                HUD.show(true)
            }
            
            let parameters: Parameters = parameter!
            var jsonResponse:JSON!
            let urlString = AppURL.BaseURL.appending("\(methodName)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print(urlString ?? "")
            
            Alamofire.request(urlString!, method: .post,parameters: parameters, encoding: URLEncoding(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .numeric)).responseJSON { (response:DataResponse<Any>) in
                switch response.result{
                case .failure(let error):
                    print(error)
                    break
                case .success(let value):
                    print(value)
                    print(response.request!)  // original URL request
                    print(response.response!) // HTTP URL response
                    print(String(data: response.data!, encoding: .utf8)!)     // server data
                    print(response.result)   // result of response serialization
                    
                    let json = JSON(data: response.data!)
                    print("\(json)")
                    jsonResponse = json
                    successHandler(jsonResponse)
                    break
                }
                
                // indicator.stopAnimating()
                HUD.hide(true)
                HUD.removeFromSuperview()
            }
        }
        else
        {
            errorJson = ["status":0,"message":"Network is Unreachable"]
            successHandler(errorJson)
            ServiceManager.alert(message: "Network is Unreachable")
        }
    }
    
    class func requestWithPostForChecker(methodName:String , parameter:[String:Any]?,isHUD:Bool,hudMsg:String,successHandler: @escaping (_ success:JSON) -> Void) {
        let errorDict:[String:Any] = [:]
        var errorJson:JSON = JSON(errorDict)
        
        
        if ReachabilityCheck.sharedInstance.isInternetAvailable(){
            // indicator.startAnimating()
            var topVC:UIViewController!
            var HUD:MBProgressHUD!
            if(isHUD)
            {
                topVC = ServiceManager.topMostController()
                HUD = MBProgressHUD(view:topVC.view)
                HUD.color = UIColor(displayP3Red: 47/255, green: 97/255, blue: 173/255, alpha: 1.0)
                UIApplication.topViewController()?.view.addSubview(HUD)
                HUD.mode = .indeterminate
                HUD.labelText = hudMsg
                HUD.show(true)
            }
            
            let parameters: Parameters = parameter!
            var jsonResponse:JSON!
          //  let urlString = baseUrl.appending("\(methodName)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlString = "\(methodName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print(urlString ?? "")
            
            

            Alamofire.request(urlString!, method: .post,parameters: parameters, encoding: URLEncoding(),headers: ServiceManager.getHeaders()).responseJSON { (response:DataResponse<Any>) in
                switch response.result{
                case .failure(let error):
                    print(error)
                    break
                case .success(let value):
                    print(value)
                    print(response.request!)  // original URL request
                    print(response.response!) // HTTP URL response
                    print(String(data: response.data!, encoding: .utf8)!)     // server data
                    print(response.result)   // result of response serialization
                    
                    let json = JSON(data: response.data!)
                    print("\(json)")
                    jsonResponse = json
                    break
                }
                successHandler(jsonResponse)
                // indicator.stopAnimating()
                HUD.hide(true)
                HUD.removeFromSuperview()
            }
        }
        else
        {
            errorJson = ["status":0,"message":"Network is Unreachable"]
            successHandler(errorJson)
            ServiceManager.alert(message: "Network is Unreachable")
        }
    }

    // Checkr API key
   class func getHeaders() -> [String: String] {
        let userName = "dc5ac9123e264a745f3264287bd0fa2449a9e49e"
        let password = ""
        let credentialData = "\(userName):\(password)".data(using: .utf8)
        guard let cred = credentialData else { return ["" : ""] }
        let base64Credentials = cred.base64EncodedData(options: [])
        guard let base64Date = Data(base64Encoded: base64Credentials) else { return ["" : ""] }
        return ["Authorization": "Basic \(base64Date.base64EncodedString())"]
    }

    
       class func requestWithPostForJob(methodName:String , parameter:[String:Any]?,isHUD:Bool,hudMsg:String,successHandler: @escaping (_ success:JSON) -> Void) {
           let errorDict:[String:Any] = [:]
           var errorJson:JSON = JSON(errorDict)
           
           if ReachabilityCheck.sharedInstance.isInternetAvailable(){
               // indicator.startAnimating()
               var topVC:UIViewController!
               var HUD:MBProgressHUD!
               if(isHUD)
               {
                   topVC = ServiceManager.topMostController()
                   HUD = MBProgressHUD(view:topVC.view)
                   HUD.color = UIColor(displayP3Red: 47/255, green: 97/255, blue: 173/255, alpha: 1.0)
                   UIApplication.topViewController()?.view.addSubview(HUD)
                   HUD.mode = .indeterminate
                   HUD.labelText = hudMsg
                   HUD.show(true)
               }
               
               let parameters: Parameters = parameter!
               var jsonResponse:JSON!
               let urlString = AppURL.BaseURL.appending("\(methodName)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
               print(urlString ?? "")
               
            Alamofire.request(urlString!, method: .post,parameters: parameters, encoding: URLEncoding.default).responseJSON { (response:DataResponse<Any>) in
                   switch response.result{
                   case .failure(let error):
                       print(error)
                       break
                   case .success(let value):
                       print(value)
                       print(response.request!)  // original URL request
                       print(response.response!) // HTTP URL response
                       print(String(data: response.data!, encoding: .utf8)!)     // server data
                       print(response.result)   // result of response serialization
                       
                       let json = JSON(data: response.data!)
                       print("\(json)")
                       jsonResponse = json
                       break
                   }
                   successHandler(jsonResponse)
                   // indicator.stopAnimating()
                   HUD.hide(true)
                   HUD.removeFromSuperview()
               }
           }
           else
           {
               errorJson = ["status":0,"message":"Network is Unreachable"]
               successHandler(errorJson)
               ServiceManager.alert(message: "Network is Unreachable")
           }
       }
           
    class func requestWithPostMultipartImage(methodName:String,image:UIImage, parameter:[String:Any]?,isHUD:Bool,hudMsg:String,successHandler: @escaping (_ success:JSON) -> Void) {
        
        if ReachabilityCheck.sharedInstance.isInternetAvailable(){
            // indicator.startAnimating()
            var topVC:UIViewController!
            var HUD:MBProgressHUD!
            if(isHUD)
            {
                topVC = ServiceManager.topMostController()
                HUD = MBProgressHUD(view:topVC.view)
                HUD.color = UIColor(displayP3Red: 47/255, green: 97/255, blue: 173/255, alpha: 1.0)
                UIApplication.topViewController()?.view.addSubview(HUD)
                HUD.mode = .indeterminate
                HUD.labelText = hudMsg
                HUD.show(true)
            }
            
            // indicator.startAnimating()
            let parameters: Parameters = parameter!
            var jsonResponse:JSON!
            let urlString = AppURL.BaseURL.appending("\(methodName)")
            print(urlString)
            
            let header: HTTPHeaders = ["Content-Type":"multipart/form-data"]
            print(header)
            
           
            
            //photo_path                // let image = UIImage(named: "image.png")
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                multipartFormData.append(image.jpegData(compressionQuality: 0.75)!, withName: "image", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                
                
                //multipartFormData.append(video, withName: "video", fileName: "video.mov", mimeType: "video/mp4")
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to: urlString, method: .post , headers: nil, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print(progress.fractionCompleted * 100)
                    })
                    
                    upload.responseJSON(completionHandler: { (response) in
                        let json = JSON(data: response.data!)
                        print("\(json)")
                        jsonResponse = json
                        //   indicator.stopAnimating()
                        //                        HUD.hide(true)
                        //                        HUD.removeFromSuperview()
                        successHandler(jsonResponse)
                        HUD.hide(true)
                        HUD.removeFromSuperview()
                    })
                case .failure(let error):
                    print(error)
                    
                    
                }
            })
        }
        else
        {
            ServiceManager.alert(message: "Network is Unreachable")
        }
    }
   
    
    class func requestWithGetForGoogle(methodName:String,hudMsg:String,parameter:[String:Any]?,isHUD:Bool ,successHandler: @escaping (_ success:JSON) -> Void) {
           let errorDict:[String:Any] = [:]
           var errorJson:JSON = JSON(errorDict)
           
           let headers: HTTPHeaders = [
               "Content-Type" : "application/json"]
           
           if ReachabilityCheck.sharedInstance.isInternetAvailable(){
               
               var topVC:UIViewController!
               var HUD:MBProgressHUD!
               if(isHUD)
               {
                   topVC = ServiceManager.topMostController()
                   HUD = MBProgressHUD(view:topVC.view)
                   HUD.color = UIColor(displayP3Red: 47/255, green: 97/255, blue: 173/255, alpha: 1.0)
                   UIApplication.topViewController()?.view.addSubview(HUD)
                   HUD.mode = .indeterminate
                   HUD.labelText = hudMsg
                   HUD.show(true)
               }
               
               var jsonResponse:JSON!
               let urlString = "\(methodName)"
               Alamofire.request(urlString, method: .get, parameters:parameter, encoding: URLEncoding() ,headers: headers).responseJSON { (response:DataResponse<Any>) in
                   switch response.result{
                   case .failure(let error):
                       print(error)
                       errorJson = ["status":0,"message":"Network Failure"]
                       print(response.request!)  // original URL requt
                       
                       print(String(data: response.data!, encoding: .utf8)!)
                       print(response.result)   // result of response serialization
                       
                       successHandler(errorJson)
                       break
                   case .success(let value):
                       print(value)
                       
                       let json = JSON(data: response.data!)
                       //                    print("\(json)")
                       jsonResponse = json
                       successHandler(jsonResponse)
                       break
                   }
                   if(isHUD)
                   {
                       HUD.hide(true)
                       HUD.removeFromSuperview()
                       
                   }
               }
           }
           else
           {
               errorJson = ["status":0,"message":"Network is Unreachable"]
               successHandler(errorJson)
               ServiceManager.alert(message: "Network is Unreachable")
           }
       }
       
    
    
  /*  class func requestWithPostMultipartdoc(methodName:String ,doc: Data , parameter:[String:Any]?, successHandler: @escaping (_ success:JSON) -> Void) {
        if(ReachabilityCheck.sharedInstance.netStatus == "WiFi" || ReachabilityCheck.sharedInstance.netStatus == "WWAN")
        {
            indicator.startAnimating()
            let parameters: Parameters = parameter!
            print(parameters)
            var jsonResponse:JSON!
            let filename = parameter?["FileName"] as! String
            let filetype = parameter?["FileType"] as! String
            print(filename)
            print(filetype)
            let urlString = baseUrl.appending("\(methodName)")
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(doc , withName: "photo_path", fileName: filename, mimeType: filetype)
                //multipartFormData.append(video, withName: "video", fileName: "video.mov", mimeType: "video/mp4")
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to: urlString, method: .post , headers:nil, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print(progress.fractionCompleted * 100)
                    })
                    
                    upload.responseJSON(completionHandler: { (response) in
                        let json = JSON(data: response.data!)
                        print("\(json)")
                        jsonResponse = json
                        indicator.stopAnimating()
                        successHandler(jsonResponse)
                    })
                case .failure(let error):
                    print(error)
                    
                    
                }
            })
        }
        else
        {
            ServiceManager.alert(message: "Network is Unreachable")
        }
    }
    */


    class func topMostController() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    class func alert(message:String){
        let alert=UIAlertController(title: "Alert", message: message, preferredStyle: .alert);
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            
        }
        alert.addAction(cancelAction)
        ServiceManager.topMostController().present(alert, animated: true, completion: nil);
    }
}

struct CustomPATCHEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        let mutableRequest = try! URLEncoding().encode(urlRequest, with: parameters) as? NSMutableURLRequest
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            mutableRequest?.httpBody = jsonData
        } catch {
            print(error.localizedDescription)
        }
        
        return mutableRequest! as URLRequest
    }
}



extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

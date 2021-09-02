//
//  APIController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 12/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//


import UIKit


class APIController: NSObject {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func getRequest(methodName:String, param:[String:Any]?,isHUD:Bool,successHandler: @escaping (_ responce:JSON) -> Void){
        //   print("methodName",methodName)
       
        ServiceManager.requestWithGet(methodName: methodName, hudMsg: "Processing...", parameter: param, isHUD: isHUD) { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    
    
    func postRequest(methodName:String,successHandler: @escaping (_ responce:JSON) -> Void){
        print("methodName",methodName)
        let params : [String:Any] = [:]
        ServiceManager.requestWithPost(methodName: methodName, parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func postRequestForChecker(methodName:String,params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
        print("methodName",methodName)
        //  let params : [String:Any] = [:]
        ServiceManager.requestWithPostForChecker(methodName: methodName, parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["error"].array == nil)
            {
                successHandler(jsonResponse)
            }
            else
            {
//                successHandler(jsonResponse)
                ServiceManager.alert(message: jsonResponse["error"].arrayValue[0].stringValue)
            }
        }
    }
    
    func postCheckerReport(methodName:String,params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
            print("methodName",methodName)
            //  let params : [String:Any] = [:]
            ServiceManager.requestWithPostForChecker(methodName: methodName, parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
                if(jsonResponse["status"].stringValue == "1")
                {
                    successHandler(jsonResponse)
                }
                else
                {
    //                successHandler(jsonResponse)
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
        
    
    func postRequestWithDict(methodName:String,params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithPost(methodName: methodName, parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func cancelSeekerJobApplication(params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithPost(methodName: "CancelSeekerJobApplication", parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
                    //                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    
    
    func jobCancelApplicationAcceptReject(params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithPost(methodName: "JobCancelApplicationAcceptReject", parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
                    //                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    func signUp(params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithPost(methodName: "SaveRegistration", parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func getPromoCodeList(successHandler: @escaping (_ responce:JSON) -> Void){
        let param:[String:Any] = [:]
        ServiceManager.requestWithPost(methodName: "GetPromoCodeList?UserId=\(AppDelegate.sharedDelegate().user_ID)", parameter: param, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func updateCandidateData(params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithPostQueryString(methodName: "UpdateCandidateData", parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func getAppLink(params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithPostQueryString(methodName: "GetAppLink", parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    
    func linkAccount(params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithGet(methodName: "RetrieveStripeAccount", hudMsg: "Processing...", parameter: params, isHUD: true) { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func getJobFee(successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithGet(methodName: "GetJobFee", hudMsg: "Processing...", parameter: nil, isHUD: true) { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func payout(params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithGet(methodName: "PayoutToConnectedAccount", hudMsg: "Processing...", parameter: params, isHUD: true) { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    
    
    func CreateJob(params:[String:Any],image:UIImage,successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithPostMultipartImage(methodName: "CreateJob", image: image, parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func EditProfile(params:[String:Any],image:UIImage,successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithPostMultipartImage(methodName: "SaveRegistration", image: image, parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func postMultipart(params:[String:Any],image:UIImage,methodName:String,successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithPostMultipartImage(methodName: methodName, image: image, parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
   func postMultipart1(methodName:String,params:[String:Any],successHandler: @escaping (_ responce:JSON) -> Void){
        ServiceManager.requestWithPost(methodName: methodName, parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    
    
    
    func uploadImages(image:UIImage,methodName:String,successHandler: @escaping (_ responce:JSON) -> Void){
        let params : [String:Any] = [:]
        ServiceManager.requestWithPostMultipartImage(methodName: methodName, image: image, parameter: params, isHUD: true, hudMsg: "Processing...") { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "1")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                        ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
    func getRequestGoogle(methodName:String,isHUD:Bool,successHandler: @escaping (_ responce:JSON) -> Void){
        print("methodName",methodName)
        let params : [String:Any] = [:]
        ServiceManager.requestWithGetForGoogle(methodName: methodName, hudMsg: "Processing...", parameter: params, isHUD: isHUD) { (jsonResponse) in
            if(jsonResponse["status"].stringValue == "OK")
            {
                successHandler(jsonResponse)
            }
            else
            {
                if jsonResponse["message"].stringValue == "" {
//                    ServiceManager.alert(message: "server under maintenance.")
                }
                else{
                    if jsonResponse["message"].stringValue == "Network Failure"{
                        
                    }else{
                    ServiceManager.alert(message: jsonResponse["message"].stringValue)
                    }
                }
            }
        }
    }
    
}

//
//  AppDelegate.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 26/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GooglePlaces
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Stripe
import UserNotifications
import Firebase
import FirebaseCore
import FirebaseDynamicLinks
import FirebaseMessaging
import FirebaseInstanceID
import AuthenticationServices
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate ,UNUserNotificationCenterDelegate, MessagingDelegate {
    var JobType = "MyListing"
    var myListRquest = "Applications"
    var myJobRquest = "Apply_Now"
    var user_ID = 0
    var token: String = ""
    var window: UIWindow?
    let Constant : CommonStrings = CommonStrings.commonStrings
    var pushData = [String:Any]()
    var pushMsgDict = [String:Any]()
    var isFromPush = false
    let userModel : UserModel = UserModel.userModel
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if UIDevice.current.localizedModel == "iPhone" {
            print("This is an iPhone")
        } else if UIDevice.current.localizedModel == "iPad" {
            print("This is an iPad")
        }
        
        if #available(iOS 13.0, *) {
                   window!.overrideUserInterfaceStyle = .light
               } else {
                   // Fallback on earlier versions
               }
//        if let userIdentifier = UserDefaults.standard.object(forKey: "userIdentifier1") as? String {
//            let authorizationProvider = ASAuthorizationAppleIDProvider()
//            authorizationProvider.getCredentialState(forUserID: userIdentifier) { (state, error) in
//                switch (state) {
//                case .authorized:
//                    print("Account Found - Signed In")
//                    DispatchQueue.main.async {
//                        let initialViewController =  Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                        (self.window?.rootViewController as! UINavigationController).pushViewController(initialViewController, animated: false)
//                    }
//                    break
//                case .revoked:
//                    print("No Account Found")
//                    fallthrough
//                case .notFound:
//                    print("No Account Found")
//                    DispatchQueue.main.async {
//                        print("Not Authrizes")
//                    }
//
//
//                default:
//                    break
//                }
//            }
//        }
        // Override point for customization after application launch.
        
        sleep(2)
        IQKeyboardManager.shared.enable = true
        
        if UserDefaults.standard.value(forKey: "login_Id") != nil{
            user_ID = UserDefaults.standard.value(forKey: "login_Id") as?  Int ?? 0
        }
        
        GMSPlacesClient.provideAPIKey(Constant.googleAPIKey)
        //AIzaSyCmjsvbSYhpc2tu9QluKnnaS5Ro0Ykcv14
//        GIDSignIn.sharedInstance().clientID = "1042323928163-ph31o1gff7lpdrebcjgtv8fv325bdqg4.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().clientID = "329922309865-ekn3jddb0n2qpa3blrjnjk5f2g3dkji2.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        //strip payment gatway
//        Stripe.setDefaultPublishableKey("pk_test_TYooMQauvdEDq54NiTphI7jx")
        // test stripe key
        Stripe.setDefaultPublishableKey("pk_test_51GtwIjJMe2sL43M0Oe33Z9hp4FoPByGtRoe7VhWnbcsdie9QN04U4ro6ATAqQsDNX7zHxgZjvHybXhrhawPNaWsU00WEZ6c8uw")
        
        
        //live stripe key
//        Stripe.setDefaultPublishableKey("pk_live_04yYAydEecXUxer0AHOMFZGW00ipY6MY3Q")
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        
        registerForPushNotifications(application: application)
        
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] {
           print(pushData)
            pushData = userInfo as! [String : Any]
            pushMsgDict = userInfo as! [String : Any]
            self.pushHendler()
        }

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) != nil {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print(userActivity.webpageURL!)
        var type = ""
        if(userActivity.webpageURL!.absoluteString.contains("Poster"))
        {
            type = "Poster"
        }
        else if(userActivity.webpageURL!.absoluteString.contains("Performer"))
        {
            type = "Performer"
        }
        else if(userActivity.webpageURL!.absoluteString.contains("Chat")){
            type = "Chat"
        }
        else if(userActivity.webpageURL!.absoluteString.contains("Message")){
             type = "Message"
        }
        else{
            
        }
        
        
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            // ...
            print(JSON(dynamiclink?.url?.queryParameters ?? "")["JobId"].stringValue )
            if(AppDelegate.sharedDelegate().user_ID == 0)
            {
                (ServiceManager.topMostController() as! UINavigationController).popToRootViewController(animated: false)
            }
            else
            {
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                LoginNavVC.viewControllers.append(LoginVC)
                
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                LoginNavVC.viewControllers.append(HomeVC)
                if(type == "Poster")
                {
                    let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                    LoginNavVC.viewControllers.append(FeedDetailVC)
                    FeedDetailVC.jobID = JSON(dynamiclink?.url?.queryParameters ?? "")["JobId"].intValue
                    FeedDetailVC.titleStr = "Feed"
                }
                else if(type == "Performer")
                {
                    let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "MyJobFeedViewController") as! MyJobFeedViewController
                    LoginNavVC.viewControllers.append(FeedDetailVC)
                    FeedDetailVC.jobID = JSON(dynamiclink?.url?.queryParameters ?? "")["JobId"].intValue
                    FeedDetailVC.titleStr = "Feed"
                }
                else if(type == "Chat"){
                   let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    LoginNavVC.viewControllers.append(FeedDetailVC)
                    FeedDetailVC.jobID = JSON(dynamiclink?.url?.queryParameters ?? "")["JobId"].intValue
                    FeedDetailVC.titleStr = "Feed"
                    FeedDetailVC.chatType = "MyJob"
                     FeedDetailVC.chatValue = "true"
                }
                else if(type == "Message") {
                   let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    LoginNavVC.viewControllers.append(FeedDetailVC)
                    FeedDetailVC.jobID = JSON(dynamiclink?.url?.queryParameters ?? "")["JobId"].intValue
                    FeedDetailVC.titleStr = "Feed"
                    FeedDetailVC.chatType = "MyListing"
                     FeedDetailVC.chatValue = "true"
                }
                else{
//                    let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                    LoginNavVC.viewControllers.append(FeedDetailVC)
////                    FeedDetailVC.jobID = JSON(dynamiclink?.url?.queryParameters ?? "")["JobId"].intValue
////                    FeedDetailVC.titleStr = "Feed"
                }
                
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }
            
        }
        
        return handled
    }
    
    func registerForPushNotifications(application: UIApplication){
          if #available(iOS 10.0, *){
              UNUserNotificationCenter.current().delegate = self
              UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                  if (granted)
                  {
                      DispatchQueue.main.async {
                          UIApplication.shared.registerForRemoteNotifications()
                      }
                  }
                  else{
                      //Do stuff if unsuccessful...
                  }
              })
          }
              
          else{ //If user is not on iOS 10 use the old methods we've been using
              let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
              application.registerUserNotificationSettings(notificationSettings)
              
          }
      }
    
    
    func pushHendler(){
        print(user_ID)
        if user_ID == pushData["toUserId"] as? Int{

        }
        print(pushData)
        print(pushData["NotificationType"] as? String)
        let push_Type = pushData["NotificationType"] as? String
        
    
        if push_Type == "Chat"{
            let state = UIApplication.shared.applicationState
            
            if state != .active{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let chatViewController = SecondStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                
                chatViewController.pushData = pushData
                chatViewController.chatValue = "true"
                                chatViewController.chatType = "MyJob"
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(chatViewController)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }else{
                self.isFromPush = true
                //                 let chatNavi: UINavigationController = SecondStoryboard.instantiateViewController(withIdentifier: "ChatNavigationViewController") as! UINavigationController
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let chatViewController = SecondStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                
                chatViewController.pushData = pushData
                chatViewController.chatValue = "true"
                 chatViewController.chatType = "MyJob"
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(chatViewController)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }
        }else if push_Type == "Job Application"{
            
            let state = UIApplication.shared.applicationState
            
            if state != .active{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                
                FeedDetailVC.pushData = pushData
                FeedDetailVC.titleStr = "Feed"
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }else{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                
                FeedDetailVC.pushData = pushData
                FeedDetailVC.titleStr = "Feed"
                
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }
        }else if push_Type == "Application Accepted" || push_Type == "Job Cancel Request" || push_Type == "Application Accept"{
            let state = UIApplication.shared.applicationState
            
            if state != .active{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "MyJobFeedViewController") as! MyJobFeedViewController
                
                FeedDetailVC.pushData = pushData
                FeedDetailVC.titleStr = "Feed"
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }else{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "MyJobFeedViewController") as! MyJobFeedViewController
                
                FeedDetailVC.pushData = pushData
                FeedDetailVC.titleStr = "Feed"
                
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }
        } else if push_Type == "offer Accept"{
            print(pushData)
            let state = UIApplication.shared.applicationState
            
            if state != .active{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                
                FeedDetailVC.pushData = pushData
                FeedDetailVC.titleStr = "Feed"
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }else{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                
                FeedDetailVC.pushData = pushData
                FeedDetailVC.titleStr = "Feed"
                
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }
        }else if push_Type == "Activity"{
            if user_ID == userModel.Id{
                let state = UIApplication.shared.applicationState
                
                if state != .active{
                    
                    self.isFromPush = true
                    
                    let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                    let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    //                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                    
                    //                FeedDetailVC.pushData = pushData
                    //                FeedDetailVC.titleStr = "Feed"
                    
                    LoginNavVC.viewControllers.append(LoginVC)
                    LoginNavVC.viewControllers.append(HomeVC)
                    //                LoginNavVC.viewControllers.append(FeedDetailVC)
                    
                    self.window?.rootViewController = LoginNavVC
                    self.window?.makeKeyAndVisible()
                    
                }else{
                    
                    self.isFromPush = true
                    
                    let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                    let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    //                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                    
                    //                FeedDetailVC.pushData = pushData
                    //                FeedDetailVC.titleStr = "Feed"
                    
                    
                    LoginNavVC.viewControllers.append(LoginVC)
                    LoginNavVC.viewControllers.append(HomeVC)
                    //                LoginNavVC.viewControllers.append(FeedDetailVC)
                    
                    self.window?.rootViewController = LoginNavVC
                    self.window?.makeKeyAndVisible()
                    
                }
            }else{
            let state = UIApplication.shared.applicationState
            
            if state != .active{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "MyJobFeedViewController") as! MyJobFeedViewController
                
                FeedDetailVC.pushData = pushData
                FeedDetailVC.titleStr = "Feed"
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }else{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "MyJobFeedViewController") as! MyJobFeedViewController
                
                FeedDetailVC.pushData = pushData
                FeedDetailVC.titleStr = "Feed"
                
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }
            }
        
        }
        else if push_Type == "Job Completed"{
            
            let state = UIApplication.shared.applicationState
            
            if state != .active{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                
                FeedDetailVC.pushData = pushData
                FeedDetailVC.titleStr = "Feed"
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }else{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                
                FeedDetailVC.pushData = pushData
                FeedDetailVC.titleStr = "Feed"
                
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }
        }
        else if push_Type == "Job Cancellation accepted" || push_Type == "Job Cancel"{
            
            let state = UIApplication.shared.applicationState
            
            if state != .active{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                
//                FeedDetailVC.pushData = pushData
//                FeedDetailVC.titleStr = "Feed"
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
//                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }else{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                
//                FeedDetailVC.pushData = pushData
//                FeedDetailVC.titleStr = "Feed"
                
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
//                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }
        }
        else {
            
            let state = UIApplication.shared.applicationState
            
            if state != .active{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                //                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                
                //                FeedDetailVC.pushData = pushData
                //                FeedDetailVC.titleStr = "Feed"
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                //                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }else{
                
                self.isFromPush = true
                
                let LoginNavVC :  UINavigationController = Mainstoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let LoginVC = Mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let HomeVC = Mainstoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                //                let FeedDetailVC = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                
                //                FeedDetailVC.pushData = pushData
                //                FeedDetailVC.titleStr = "Feed"
                
                
                LoginNavVC.viewControllers.append(LoginVC)
                LoginNavVC.viewControllers.append(HomeVC)
                //                LoginNavVC.viewControllers.append(FeedDetailVC)
                
                self.window?.rootViewController = LoginNavVC
                self.window?.makeKeyAndVisible()
                
            }
        }
       
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo

      //  print("user clicked on the notification")
        print("Push notification received: \(userInfo)")
        pushData = userInfo as! [String : Any]
        pushMsgDict = userInfo as! [String : Any]
        self.pushHendler()
        
        completionHandler()
    }

    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        pushMsgDict = data as! [String : Any]

    }
       
//       func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//           application.applicationIconBadgeNumber = 0
//       }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let push_Type = pushMsgDict["NotificationType"] as? String
        
        
        // Handle Chat PUSH
        if push_Type == "Chat"{
            if let topVC = UIApplication.getTopViewController() {
                
                if topVC is ChatViewController {
                   // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Receive_Chat"), object: nil, userInfo: ["status":true])

                    completionHandler([])
                }
                else{
                    completionHandler([.alert, .badge, .sound])
                }
            }
            
        }else{
            completionHandler([.alert, .badge, .sound])
        }
        
        
    }
       func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
           // Convert token to string
           let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
           // Print it to console
           print("APNs device token: \(deviceTokenString)")
           token = deviceTokenString
           Messaging.messaging().apnsToken = deviceToken
           UserDefaults.standard.set(token, forKey: "token")
           UserDefaults.standard.synchronize()
           // Persist it in your backend in case it's new
       }
       
       // Called when APNs failed to register the device for push notifications
       func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
           // Print the error to console (you should alert the user that registration failed)
           print("APNs registration failed: \(error)")
           token = "E0BE5B14205F165CADEBA7C22C0B87C283B00303022510D12A0E539E74AEC454"
           //   token = "052CAF34CC231D5F0EDB81EB50E6C6CEC1DDE23C96ED126264A884DC9A78A519" D658E085CE7B1DFE0F082354BCA2E6CB8B7D45F964B09D9EA06D6D4CE6EFE95E
           UserDefaults.standard.set(token, forKey: "token")
           UserDefaults.standard.synchronize()
       }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            _ = user.userID                  // For client-side use only!
            _ = user.authentication.idToken // Safe to send to the server
            _ = user.profile.name
            _ = user.profile.givenName
            _ = user.profile.familyName
            _ = user.profile.email
            // ...
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
          //        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
          //                                                                sourceApplication: sourceApplication,
          //                                                                annotation: annotation)
          //
        let facebookDidHandle = ApplicationDelegate.shared.application(
              application,
              open: url,
              sourceApplication: sourceApplication,
              annotation: annotation)
        let deeplink = ApplicationDelegate.shared.application(application, open: url,
                        sourceApplication: sourceApplication,
                        annotation: "")
        //  return facebookDidHandle
          
           return GIDSignIn.sharedInstance().handle(url) || facebookDidHandle || deeplink
      }
      
    

    func applicationWillResignActive(_ application: UIApplication) {
           // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
           // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
       }
       
       func applicationDidEnterBackground(_ application: UIApplication) {
           // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
           // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       }
       
       func applicationWillEnterForeground(_ application: UIApplication) {
           // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
            NotificationCenter.default.post(name: Notification.Name("WillEnterForground"), object: nil)

       }
       
       func applicationDidBecomeActive(_ application: UIApplication) {
           // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       }
       
       
       
       func applicationWillTerminate(_ application: UIApplication) {
           // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
           // Saves changes in the application's managed object context before the application terminates.
           self.saveContext()
       }
    
    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Azzida")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    class func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

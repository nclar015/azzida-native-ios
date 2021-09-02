//
//  NotMyJobPopUpVC.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 08/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class NotMyJobPopUpVC: UIViewController {
    
    @IBOutlet weak var RateView: FloatRatingView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var listerImg: UIImageView!


    let appDel = UIApplication.shared.delegate as! AppDelegate
    var Rating : Float = 0
    var Ratingstr = ""
    var JobData = JSON()
    var listerName = ""
    var listerImage = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        RateView.delegate = self
        RateView.type = .halfRatings
        listerImg.downloadImage(url: listerImage)
        lblName.text = " Rate \(listerName) to Mark Job as Complete ?"
        // Do any additional setup after loading the view. How was Bill Withers?
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        //SaveRate userid me  ListerId jae gi
        // UserId, JobId, Rate, SeekerId
        
        if Ratingstr == ""  {
           Ratingstr = "0.0"
        }
        print(Ratingstr)
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "SaveRate?UserId=\(self.JobData["ListerId"].intValue)&JobId=\(self.JobData["JobId"].intValue)&Rate=\(Ratingstr)&SeekerId=\(appDel.user_ID)&applink=") { (responce) in
            if responce["message"].stringValue == "success"{
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Back_To_Feed"), object: nil, userInfo: ["status":true])
                }
            }
        }
        //        appDel.myListRquest = "Confirmed"
        //        self.dismiss(animated: true, completion: nil)
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Back_To_Feed"), object: nil, userInfo: ["status":true])
        
    }

    @IBAction func btnShare(_ sender: UIButton) {
        let imageLink = JobData["data"]["imageList"].arrayValue.first?.stringValue ?? ""
        Utilities.createShareLink(jobid: self.JobData["JobId"].stringValue, image: imageLink) { (url) in
            DispatchQueue.main.async {
                let shareString = "Let me recommend you this Job\n\n\(url)\n\n"
                let items = [shareString]
                if UIDevice.current.localizedModel == "iPhone" {
                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    print(ac)
                    self.present(ac, animated: true)
                } else if UIDevice.current.localizedModel == "iPad" {
                    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    activityVC.title = "Share"
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                    if let popoverController = activityVC.popoverPresentationController {
                        print(UIScreen.main.bounds.height)
                        print(UIScreen.main.bounds.width)
                        popoverController.sourceRect = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height / 2)
                        popoverController.sourceView = self.view
                        popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                    }
                    
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
        }
        
    }
    
}

extension NotMyJobPopUpVC: FloatRatingViewDelegate {

    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
      //  print("1")
       // print(String(format: "%.2f", self.RateView.rating))
       // liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
       // print("2")
        print(String(format: "%.1f", self.RateView.rating))
        Ratingstr = String(format: "%.1f", self.RateView.rating)
        //updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
}


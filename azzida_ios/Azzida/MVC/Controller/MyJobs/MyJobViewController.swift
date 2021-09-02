//
//  MyJobViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 28/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class MyJobViewController: UIViewController {
    
    @IBOutlet weak var tblActivity : UITableView!
    let userModel : UserModel = UserModel.userModel
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var MethodName = ""
    var data : [JSON] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        tblActivity.register(UINib(nibName: "JobsListTableViewCell", bundle: nil), forCellReuseIdentifier: "JobsListTableViewCell")
        
        tblActivity.rowHeight = UITableView.automaticDimension
        tblActivity.estimatedRowHeight = 200
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(userModel.JobType)
        self.tblActivity.isHidden = true        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GetJob()
    }
    
    
    @objc func setText(){
        // self.title = "My_Jobs".localized()
    }
    
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func GetJob(){
        if userModel.JobTypeProfile == "My_Jobs" {
            
            if userModel.JobType == "IN_PROGRESS" {
                MethodName = "SeekerInprogressJob"
            }
            else if  userModel.JobType == "COMPLETED" {
                MethodName = "SeekerCompletedJob"
            }
            else{
                //   Alert.alert(message: "", title: "No Data Found.")
                MethodName = "SeekerJobCancelledList"
            }
            
        }else{
            
            if userModel.JobType == "IN_PROGRESS" {
                MethodName = "ListerInProgressJob"
            }
            else if  userModel.JobType == "COMPLETED" {
                MethodName = "ListerCompletedJob"
            }else{
                MethodName = "ListerJobCancelledList"
                //                Alert.alert(message: "", title: "No Data Found.")
                //                return
            }
        }
        
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "UserId":appDelegate.user_ID
        ]
        apiController.getRequest(methodName: MethodName,param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success"{
                self.data = responce["data"].arrayValue
                self.tblActivity.isHidden = false
                
                DispatchQueue.main.async {
                    self.tblActivity.reloadData()
                }
            }
        }
    }
    
    //    SeekerInprogressJob
    //    ListerInProgressJob
    //    SeekerCompletedJob  ListerJobCancelledList
    
    
    
}

extension MyJobViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 {
            self.tblActivity.setEmptyMessage("No data found.")
        } else {
            self.tblActivity.restore()
        }
        return data.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobsListTableViewCell", for: indexPath) as! JobsListTableViewCell
        
        
        //MY JOBS
        if userModel.JobTypeProfile == "My_Jobs"{
            
            if userModel.JobType == "IN_PROGRESS"{
                if data[indexPath.row]["IsApply"].boolValue{
                    cell.lblDetail.text = "Applied"
                }
                if data[indexPath.row]["ApplicationAccepted"].boolValue{
                    cell.lblDetail.text = "Application Accepted"
                }
                
                if data[indexPath.row]["OfferAccepted"].boolValue{
                    cell.lblDetail.text = "Active Awaiting Completion"
                }
                if data[indexPath.row]["IsComplete"].boolValue{
                    cell.lblDetail.text = "Completion Pending"
                }
            }
            else if  userModel.JobType == "COMPLETED" {
                print(data[indexPath.row]["CompletedDate"].doubleValue)
                cell.lblDetail.text = "Completed \(CommonStrings.getJobListDate(timeStamp: data[indexPath.row]["CompletedDate"].doubleValue))"
            }
            else{
                cell.lblDetail.text = data[indexPath.row]["Status"].stringValue
            }
        }
        else{
            //MY LISTING
            if userModel.JobType == "IN_PROGRESS"{
                cell.lblDetail.text = "\(data[indexPath.row]["ApplicantCount"].intValue) Applications"
                
                if data[indexPath.row]["ApplicationAccepted"].boolValue{
                    cell.lblDetail.text = "Application Pending"
                }
                if data[indexPath.row]["OfferAccepted"].boolValue{
                    cell.lblDetail.text = "Active Awaiting Completion"
                }
                
                if data[indexPath.row]["IsComplete"].boolValue{
                    cell.lblDetail.text = "Completion Pending"
                }
                
            }
                
            else if  userModel.JobType == "COMPLETED" {
                cell.lblDetail.text = "Completed \(CommonStrings.getJobListDate(timeStamp: data[indexPath.row]["CompletedDate"].doubleValue))"
            }
                
            else{
                if data[indexPath.row]["Status"].stringValue == "Cancelled"{
                    let dateValue = data[indexPath.row]["CancelDate"].stringValue
                    var cleanValue = dateValue.replacingOccurrences(of: "/Date(", with: "", options: .literal, range: nil)
                    cleanValue = cleanValue.replacingOccurrences(of: ")/", with: "", options: .literal, range: nil)
                    let timeSstammpValue = Double(cleanValue)
                    cell.lblDetail.text = "Cancelled \(CommonStrings.getJobListDate(timeStamp: timeSstammpValue!))"
                }
                else if data[indexPath.row]["Status"].stringValue == "Expired" {
                    cell.lblDetail.text = "Expired \(CommonStrings.getJobListDate(timeStamp: data[indexPath.row]["FromDate"].doubleValue))"
                }
                else{
                    cell.lblDetail.text = data[indexPath.row]["Status"].stringValue
                }
            }
            
        }
        
        cell.lblName.text = data[indexPath.row]["JobTitle"].stringValue
        cell.lblPrice.text = " $\(data[indexPath.row]["Amount"].stringValue)" + "   "
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
        if userModel.JobTypeProfile == "My_Jobs"{
            if userModel.JobType == "IN_PROGRESS"{
                
                let vc = SecondStoryboard.instantiateViewController(withIdentifier: "MyJobFeedViewController") as! MyJobFeedViewController
                vc.listJSON = data[indexPath.row]
                vc.jobID = data[indexPath.row]["JobId"].intValue
                vc.currantlat = self.userModel.currantlat
                vc.currantlong = self.userModel.currantlong
                vc.titleStr = "My Jobs"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if  userModel.JobType == "COMPLETED" {
                
                
                //-------------------------New Updated Code----------------------------------------------------
                let vc = SecondStoryboard.instantiateViewController(withIdentifier: "MyJobFeedViewController") as! MyJobFeedViewController
                vc.listJSON = data[indexPath.row]
                vc.jobID = data[indexPath.row]["Id"].intValue
                vc.currantlat = self.userModel.currantlat
                vc.currantlong = self.userModel.currantlong
                vc.titleStr = "My Jobs"
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                
            }
            else{
                if data[indexPath.row]["Status"].stringValue == "Not Selected" {
                    let vc = SecondStoryboard.instantiateViewController(withIdentifier: "MyJobFeedViewController") as! MyJobFeedViewController
                    vc.listJSON = data[indexPath.row]
                    vc.jobID = data[indexPath.row]["JobId"].intValue
                    vc.currantlat = self.userModel.currantlat
                    vc.currantlong = self.userModel.currantlong
                    vc.titleStr = "My Jobs"
                    vc.JobStatus = data[indexPath.row]["Status"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{
            
            if userModel.JobType == "IN_PROGRESS"{
                let vc = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                vc.jobID = data[indexPath.row]["JobId"].intValue
                vc.currantlat = self.userModel.currantlat
                vc.currantlong = self.userModel.currantlong
                vc.titleStr = "My Listing"
                vc.hideBtn = 1
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else
                
                //Update
                //------------------------------Code Updated in ios-----------------------------------------------
                if userModel.JobType == "COMPLETED"{
                    /*
                     If job is in Complete then detail page will not open from My listing
                     let vc = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                     vc.jobID = data[indexPath.row]["Id"].intValue
                     vc.currantlat = self.userModel.currantlat
                     vc.currantlong = self.userModel.currantlong
                     vc.titleStr = "My Listing"
                     vc.hideBtn = 0
                     
                     self.navigationController?.pushViewController(vc, animated: true)
                     */
                }else
                    if userModel.JobType == "CANCELED"{
                        //                if data[indexPath.row]["Status"].stringValue == "Expired" {
                        let vc = SecondStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                        vc.jobID = data[indexPath.row]["JobId"].intValue
                        vc.currantlat = self.userModel.currantlat
                        vc.currantlong = self.userModel.currantlong
                        vc.titleStr = "My Listing"
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        //                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



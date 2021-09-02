//
//  JobPostedUserViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 08/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class JobPostedUserViewController: UIViewController {
    
    @IBOutlet weak var tblActivity : UITableView!
    @IBOutlet weak var tblActivityHeight : NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblJobListed: UILabel!
    @IBOutlet weak var lblJobCompleted: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRating: UILabel!
        @IBOutlet weak var imgVerified: UIImageView!
    
    var Showlabel = UILabel()
    var ListerID = 0
    var RecentActivityData : [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLabel()

        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        tblActivity.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCell")
        tblActivity.rowHeight = UITableView.automaticDimension
        tblActivity.estimatedRowHeight = 120
        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        ratingView.type = .halfRatings
        ratingView.isUserInteractionEnabled = false
        ViewListerUser()
    }
    
    func ViewListerUser(){
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "UserId":ListerID
        ]
        apiController.getRequest(methodName: "ViewListerUser", param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success"{
                self.RecentActivityData =  responce["data"]["Getrecentactivity"].arrayValue
                
                DispatchQueue.main.async {
                    if(responce["data"]["ReportStatus"].stringValue == "clear")
                                   {
                                       self.imgVerified.isHidden = false
                                   }
                                   else
                                   {
                                       self.imgVerified.isHidden = true
                                   }
                    if(responce["data"]["RateAvg"].doubleValue != 0)
                    {
                        self.ratingView.rating = responce["data"]["RateAvg"].doubleValue
                        self.lblRating.text = "(\(responce["data"]["RatingUserCount"].intValue))"
                    }
                    else
                    {
                        self.ratingView.isHidden = true
                        self.lblRating.isHidden = true
                    }

                    self.userImageView.downloadImage(url: responce["data"]["ProfilePicture"].stringValue)
                    self.lblName.text = responce["data"]["Name"].stringValue
                    self.lblJobListed.text = "\(responce["data"]["JobPostingcount"].intValue)"
                    self.lblJobCompleted.text = "\(responce["data"]["JobCompleteCount"].intValue)"

                    var Joindate = responce["data"]["joinDate"].stringValue
                    Joindate = Joindate.replacingOccurrences(of: "/Date(", with: "")
                    Joindate = Joindate.replacingOccurrences(of: ")/", with: "")

                    self.lblDate.text = "Joined Azzida: " + CommonStrings.getFromatedDate(timeStamp: (Joindate as NSString).doubleValue)

                    self.tblActivity.reloadData()
                    
                }

            }
        }
    }
    
    func alertLabel(){
           Showlabel = UILabel(frame: CGRect(x: 0, y: view.frame.size.height/2 + 50, width: view.frame.width, height: 100))
           Showlabel.textAlignment = .center
           Showlabel.numberOfLines = 0
           Showlabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
           Showlabel.textColor = .gray
           self.view.addSubview(Showlabel)
           Showlabel.isHidden = true
         //  Showlabel.text = text
       }
       
       func hideLabel(text:String,bool:Bool){
           Showlabel.text = text
           Showlabel.isHidden = bool
       }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setText(){
        // self.title = "My_Jobs".localized()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if RecentActivityData.count > 0 {
            self.tblActivity.layoutIfNeeded()
            self.tblActivityHeight.constant = tblActivity.contentSize.height
        }
    }
        
}

extension JobPostedUserViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if RecentActivityData.count == 0 {
            self.tblActivity.setEmptyMessage("No Data Found.")
        } else {
            self.tblActivity.restore()
        }
        
        
        return RecentActivityData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        cell.lblName.text = RecentActivityData[indexPath.row]["JobTitle"].stringValue
        cell.lblDetail.text = "Jobs Performed \(Date(milliseconds: RecentActivityData[indexPath.row]["CompletedDate"].intValue).timeAgo()) ago"
        cell.lblPrice.text = " $" + RecentActivityData[indexPath.row]["Amount"].stringValue + "   "
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



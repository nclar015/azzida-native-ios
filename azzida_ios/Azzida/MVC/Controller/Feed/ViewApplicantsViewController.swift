//
//  ViewApplicantsViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 05/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class ViewApplicantsViewController: UIViewController {

    @IBOutlet weak var tblView : UITableView!
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let Constant : CommonStrings = CommonStrings.commonStrings
    var jobId = 0
    var data: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "ViewApplicantsTableCell", bundle: nil), forCellReuseIdentifier: "ViewApplicantsTableCell")
        GetViewApplicantList()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func GetViewApplicantList(){
        let apiController : APIController = APIController()
        let param:[String:Any] = [
            "JobId":jobId
        ]
        apiController.getRequest(methodName: "ViewApplicantList", param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success"{
                self.data = responce["data"].arrayValue
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }   
}

extension ViewApplicantsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 {
            self.tblView.setEmptyMessage("No Applicant's Found.")
        } else {
            self.tblView.restore()
        }
        
        
        return self.data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewApplicantsTableCell", for: indexPath) as! ViewApplicantsTableCell
        cell.lblName.text = "\(self.data[indexPath.row]["FirstName"].stringValue ) " + self.data[indexPath.row]["LastName"].stringValue
        cell.lblDetail.text = "\(self.data[indexPath.row]["JobCompleteCount"].intValue) Jobs " + "Completed".localized()
        cell.imgView.downloadImage(url:self.data[indexPath.row]["ProfilePicture"].stringValue)
        if traitCollection.userInterfaceStyle == .dark
        {
            cell.lblName.textColor = UIColor.white
            cell.lblDetail.textColor = UIColor.white
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ViewApplicantsTableCell
        let vc = SecondStoryboard.instantiateViewController(withIdentifier: "ViewOneApplicantsViewController") as! ViewOneApplicantsViewController
        vc.jobId = jobId
        vc.SeekerId = self.data[indexPath.row]["SeekerId"].intValue
        vc.selectedName = cell.lblName.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

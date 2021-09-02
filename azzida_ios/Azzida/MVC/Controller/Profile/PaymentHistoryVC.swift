//
//  PaymentHistoryVC.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 28/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class PaymentHistoryVC: UIViewController {
    
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnTitle : UIButton!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var data : [JSON] = []
    
    let constant : CommonStrings = CommonStrings.commonStrings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        
        tblView.register(UINib(nibName: "PaymentInfoCell", bundle: nil), forCellReuseIdentifier: "PaymentInfoCell")
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 300
        ViewPaymentTransaction()
    }
    
    @objc func setText(){
        lblTitle.text = "Payments".localized() + " / " + "Transactions".localized()
        btnTitle.setTitle("Back_To_Profile".localized(), for: .normal)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func ViewPaymentTransaction(){
        let apiController : APIController = APIController()
        let param:[String:Any] = ["UserId":appDelegate.user_ID]
        
        apiController.getRequest(methodName: "ViewPaymentTransaction",param: param, isHUD: true) { (responce) in
            if responce["message"].stringValue == "success" {
                //----------------------------------New Update------------------------------------
                
                
             /*for(int i = 0; i < result.getData().size(); i++)
             {
                if((result.getData().get(i).getListerPaymentDone() || result.getData().get(i).getSeekerPaymentDone()))
                {
                    if (result.getData().get(i).getReceivedFrom() != null)
                    {
                        if (result.getData().get(i).getSeekerPaymentDone())
                        {
                            viewPaymentTransactionModelData.add(result.getData().get(i));
                        }
                    }
                    else
                    {
                        viewPaymentTransactionModelData.add(result.getData().get(i));
                    }
                }
            }*/
                
                
                for item in responce["data"].arrayValue {
                    
                    if(item["IsListerPaymentDone"].boolValue || item["IsSeekerPaymentDone"].boolValue){
                        
                        if(item["ReceivedFrom"].intValue != 0){
                            
                            if(item["IsSeekerPaymentDone"].boolValue){
                                //----Edit Code
                                self.data.append(item)
                            }
                            
                        }else{
                            //-----Edit Code
                            self.data.append(item)
                        }
                        
                    }
                }
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
            
            
            
            
            
            //----------------------------------End New Code----------------------------------
//            self.data = responce["data"].arrayValue
            
            
            
            
        }
        
    }
}


extension PaymentHistoryVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 {
            self.tblView.setEmptyMessage("No Payments/Transactions Found")
        } else {
            self.tblView.restore()
        }
        
        
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentInfoCell", for: indexPath) as! PaymentInfoCell
        
        
        
        if data[indexPath.row]["ReceivedFrom"].intValue == 0 {
            
            
            
            if(data[indexPath.row]["PaymentType"].stringValue == "Dispute"){
                cell.lblName.text = "Admin (Dispute)"
            }else if(data[indexPath.row]["PaymentType"].stringValue == "Checker"){
                cell.lblName.text = "Admin (Azzida Check)"
            }else if(data[indexPath.row]["PaymentType"] == "payment"){
                
                print("---------------************\(data[indexPath.row]["ToName"])************-------------------")
                
                cell.lblName.text = data[indexPath.row]["ToName"].stringValue+" for "+data[indexPath.row]["JobTitle"].stringValue
            }else if(data[indexPath.row]["PaymentType"] == "CancelJob"){
                cell.lblName.text = "Admin(Cancled Job)"
            }else{
                cell.lblName.text = "\(data[indexPath.row]["ToName"].stringValue) for \(data[indexPath.row]["JobTitle"].stringValue)"
            }
            //cell.lblName.text = data[indexPath.row]["ToName"].stringValue
            cell.lblDetail.text = data[indexPath.row]["JobTitle"].stringValue
            cell.lblprice.layer.borderColor = UIColor.red.cgColor
            cell.lblprice.textColor = UIColor.red
            cell.lblType.text = "\("PaidTo".localized()) "
            cell.userImg.downloadImage(url: data[indexPath.row]["ToProfilePicture"].stringValue)
            
            cell.lblprice.text = "$\(String(format: "%.2f", data[indexPath.row]["TotalAmount"].doubleValue))"
            
        }else{
            if(data[indexPath.row]["PaymentType"].stringValue == "Dispute"){
                cell.lblName.text = "Admin (Dispute)"
            }else if(data[indexPath.row]["PaymentType"].stringValue == "Checker"){
                cell.lblName.text = "Admin (Azzida Check)"
            }else{
                cell.lblName.text = data[indexPath.row]["SenderName"].stringValue
            }
            
            cell.lblDetail.text = data[indexPath.row]["JobTitle"].stringValue
            cell.lblprice.layer.borderColor = constant.theamGreenColor.cgColor
            cell.lblprice.textColor = constant.theamGreenColor
            cell.lblType.text = "Received_From".localized()
            cell.userImg.downloadImage(url: data[indexPath.row]["SenderProfilePicture"].stringValue)
            
            cell.lblprice.text = "$\(String(format: "%.2f", data[indexPath.row]["SeekerPaymentAmount"].doubleValue))"
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SecondStoryboard.instantiateViewController(withIdentifier: "JobDetailsPopUpViewController") as! JobDetailsPopUpViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.JobId = self.data[indexPath.row]["JobId"].intValue
        vc.JobAmount = "$\(String(format: "%.2f", data[indexPath.row]["JobAmount"].doubleValue))"
        
        if( self.data[indexPath.row]["SeekerPaymentAmount"].intValue == 0)
        {
            vc.TotalAmount = "$\(String(format: "%.2f", data[indexPath.row]["TotalAmount"].doubleValue))"
          

        }
        else
        {
            vc.TotalAmount = "$\(self.data[indexPath.row]["SeekerPaymentAmount"].stringValue)"
        }
        
        if(self.data[indexPath.row]["PaymentType"].stringValue.lowercased() == "Payment".lowercased())
        {
            if( self.data[indexPath.row]["ReceivedFrom"].intValue != 0)
            {
                let fees = self.data[indexPath.row]["JobAmount"].doubleValue - self.data[indexPath.row]["SeekerPaymentAmount"].doubleValue
                vc.Fees = "$\(String(format: "%.2f", fees))"
            }
            else
            {
                let fees = self.data[indexPath.row]["TotalAmount"].doubleValue - self.data[indexPath.row]["JobAmount"].doubleValue
                vc.Fees = "$\(String(format: "%.2f", fees))"
            }
        }
        else
        {
            vc.Fees = "$0"
        }
        
        //------------------------------------------------------------------
        
        if data[indexPath.row]["ReceivedFrom"].intValue == 0
        {
           if(data[indexPath.row]["PaymentType"].stringValue == "Dispute")
           {
               vc.posterName = "Admin (Dispute)"
           }
           else if(data[indexPath.row]["PaymentType"].stringValue == "Checker")
           {
               vc.posterName = "Admin (Azzida Check)"
           }
           else if(data[indexPath.row]["PaymentType"] == "payment")
           {
               print("---------------************\(data[indexPath.row]["ToName"])************-------------------")
               vc.posterName = data[indexPath.row]["ToName"].stringValue+" for "+data[indexPath.row]["JobTitle"].stringValue
           }
           else if(data[indexPath.row]["PaymentType"] == "CancelJob")
           {
                vc.posterName = "Admin(Cancled Job)"
           }
           else
           {
                vc.posterName = "\(UserModel.userModel.FirstName) \(UserModel.userModel.LastName)"
           }
        }
        else
        {
           if(data[indexPath.row]["PaymentType"].stringValue == "Dispute"){
               vc.posterName = "Admin (Dispute)"
           }else if(data[indexPath.row]["PaymentType"].stringValue == "Checker"){
               vc.posterName = "Admin (Azzida Check)"
           }else{
               vc.posterName = data[indexPath.row]["SenderName"].stringValue
           }
        }
        //------------------------------------------------------------------
        
        
        
        
        vc.paymentType = self.data[indexPath.row]["PaymentType"].stringValue
        vc.performerName = self.data[indexPath.row]["ToName"].stringValue
        vc.date = CommonStrings.getDateFromTimeStamp(timeStamp: self.data[indexPath.row]["CreatedDate"].doubleValue)
        vc.jobNameTitle = self.data[indexPath.row]["JobTitle"].stringValue
        
        ///*
        if(data[indexPath.row]["PaymentType"].stringValue.lowercased() == "payment")
        {
            if(data[indexPath.row]["ReceivedFrom"].intValue != 0)
            {
                let JobAmount:Double = data[indexPath.row]["JobAmount"].doubleValue
                let SeekerAmount:Double = data[indexPath.row]["SeekerPaymentAmount"].doubleValue
                let FeeAmount:Double = JobAmount-SeekerAmount

                let Amount:String = "\(FeeAmount.rounded(toPlaces: 2))"

                vc.Fees = Amount
                vc.TotalAmount =  "\(SeekerAmount.rounded(toPlaces: 2))"
            }
            else
            {
                let fees = self.data[indexPath.row]["TotalAmount"].doubleValue - self.data[indexPath.row]["JobAmount"].doubleValue
                vc.Fees = "$\(String(format: "%.2f", fees.rounded(toPlaces: 2)))"
                vc.TotalAmount = "$\(String(format: "%.2f", data[indexPath.row]["TotalAmount"].doubleValue.rounded(toPlaces: 2)))"
            }
        }
        else
        {
            let TotalAmount:Double = data[indexPath.row]["TotalAmount"].doubleValue
            vc.Fees = "$0.00"
            vc.TotalAmount =  "$\(String(format: "%.2f", data[indexPath.row]["TotalAmount"].doubleValue.rounded(toPlaces: 2)))"
            print(TotalAmount)
        }

        //2).
        if(data[indexPath.row]["PaymentType"].stringValue.lowercased() == "checker")
        {

            vc.jobNameTitle = "Azzida Check"


        }
        else
        {
            vc.jobNameTitle = data[indexPath.row]["JobTitle"].stringValue
        }


        //3).
        if(data[indexPath.row]["ListerId"].intValue != 0)
        {
            vc.posterName =  "\(UserModel.userModel.FirstName) \(UserModel.userModel.LastName)"
            vc.performerName = data[indexPath.row]["ToName"].stringValue
            if(data[indexPath.row]["PaymentType"].stringValue.lowercased() == "payment")
            {
                vc.paymentType = "Job Payment"

            }
            else
            {
                vc.paymentType = data[indexPath.row]["PaymentType"].stringValue
            }

        }
        else
        {

            vc.posterName = data[indexPath.row]["SenderName"].stringValue
            vc.performerName = "\(UserModel.userModel.FirstName) \(UserModel.userModel.LastName)"
            if(data[indexPath.row]["PaymentType"].stringValue.lowercased() == "payment")
            {
                vc.paymentType = "Job Payment"
            }
            else
            {
                vc.paymentType =  data[indexPath.row]["PaymentType"].stringValue
            }
        }

        //4).
        if(data[indexPath.row]["PaymentType"].stringValue.lowercased() == "dispute")
        {
            vc.lblDateText =  "Date of dispute"
            let date = Utilities.getDate(dateString: data[indexPath.row]["CreatedDate"].stringValue, format: nil)
            vc.date = Utilities.getDateString(date: date, format: "MM/dd/yyyy")
        }
        else if(data[indexPath.row]["PaymentType"].stringValue.lowercased() == "checker")
        {
            vc.lblDateText = "Date of Azzida Check"
            let date = Utilities.getDate(dateString: data[indexPath.row]["CreatedDate"].stringValue, format: nil)
            vc.date = Utilities.getDateString(date: date, format: "MM/dd/yyyy")
        }
        else
        {
            vc.lblDateText = "Date of job completion"
            let date = Utilities.getDate(dateString: data[indexPath.row]["CreatedDate"].stringValue, format: nil)
            vc.date = Utilities.getDateString(date: date, format: "MM/dd/yyyy")
        }


        // */
        
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//
//  JobDetailsPopUpViewController.swift
//  Azzida
//
//  Created by iVishnu on 04/09/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class JobDetailsPopUpViewController: UIViewController {
    
    
    
    
    //-------------------------------Updated Code----------------------------------------
    
    
    @IBOutlet weak var lblJobPoster: UILabel!
    //@IBOutlet weak var lblPerformerName: UILabel!
    @IBOutlet weak var lblPerformerName : UILabel!
    @IBOutlet weak var lblDateOfJobCompletion: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    
    
    //----------------------------------------------------
    
    @IBOutlet weak var lblPosterName : UILabel!

    @IBOutlet weak var lblDateOF : UILabel!
    @IBOutlet weak var lblJobName : UILabel!
    @IBOutlet weak var lblPaymentTypeValue: UILabel!
    @IBOutlet weak var lblPerformerNameBase: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblFeesTitle: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    
    
    @IBOutlet weak var lblJobAmount: UILabel!
    @IBOutlet weak var lblFees: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let Constant : CommonStrings = CommonStrings.commonStrings
    var JobId = 0
    var JobAmount = ""
    var TotalAmount = ""
    var Fees = ""
    var paymentType = ""
    var posterName = ""
    var performerName = ""
    var date = ""
    var jobNameTitle = ""
    var lblDateText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //GetJobDetail()
        updateScreen()
        
        
      //----------------------------Updated Code-------------------------------------
        if traitCollection.userInterfaceStyle == .dark{
            lblJobPoster.textColor = UIColor.white
            lblPerformerName.textColor = UIColor.white
            lblDateOfJobCompletion.textColor = UIColor.white
            lblPaymentType.textColor = UIColor.white
            
            
            
            
            lblPosterName.textColor = UIColor.darkGray
            lblDateOF.textColor = UIColor.darkGray
            lblPerformerNameBase.textColor = UIColor.darkGray
            lblPaymentTypeValue.textColor = UIColor.darkGray
            
            
            
            self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            
            
        }else{
            
            lblJobPoster.textColor = UIColor.black
            lblPerformerName.textColor = UIColor.black
            lblDateOfJobCompletion.textColor = UIColor.black
            lblPaymentType.textColor = UIColor.black
            
            
            
            
            lblPosterName.textColor = UIColor.darkGray
            lblDateOF.textColor = UIColor.darkGray
            lblPerformerNameBase.textColor = UIColor.darkGray
            lblPaymentTypeValue.textColor = UIColor.darkGray
            
            
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
        }
        
        
        //------------------------------------------------
        

    }
    
    @IBAction func btnClose(_ sender: UIButton) {
           self.dismiss(animated: true, completion: nil)
      }
    
    func updateScreen(){
        self.lblPaymentTypeValue.text = self.paymentType

        self.lblJobAmount.text = self.JobAmount
        self.lblTotal.text = self.TotalAmount
        self.lblFees.text = self.Fees
        self.lblPosterName.text = self.posterName
        self.lblPerformerNameBase.text = self.performerName
        self.lblDateOF.text = self.date
        self.lblJobName.text = self.jobNameTitle
    }
    



}

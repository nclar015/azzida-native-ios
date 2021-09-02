//
//  ForgotPasswordViewController.swift
//  Azzida
//
//  Created by iVishnu on 05/08/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var BGView : UIView!
    @IBOutlet weak var BtnSumbit : UIButton!
    @IBOutlet weak var lblForgotPass : UILabel!
    @IBOutlet weak var lblWelcome : UILabel!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var BtnClose : UIButton!

    
    let constant : CommonStrings = CommonStrings.commonStrings
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        txtEmail.delegate = self
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        BGView.addShdow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func setText(){
        lblWelcome.text = "Welcome_To_Azzida".localized()
        lblForgotPass.text = "Forgot_Password".localized()
        txtEmail.changePlaceHolder(text: "Email".localized())
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if (txtEmail.text!.isEmpty){
            Alert.alert(message:"Enter your registered email id.", title: "Alert")
            return
        }
        
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "ForgotPassword?Email=\(txtEmail.text ?? "")") { (responce) in
            
            if responce["message"].stringValue == "success"{
                Alert.alert(message:"", title: " Reset email sent successfully ")
            }
        }
    }
    
    
    
}

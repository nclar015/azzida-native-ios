//
//  EditPaymentViewController.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 28/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class EditPaymentViewController: UIViewController {
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var btnAddPayment: UIButton!
    @IBOutlet weak var lblManagepayment: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnBackProfile: UIButton!
    @IBOutlet weak var btnAddPaymetTop: NSLayoutConstraint!

    
    var PaymentMode = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var data : [JSON] = []
    var cardIndex = 0
    var cardNumber = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.setText()
        tblView.register(UINib(nibName: "EditPaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "EditPaymentTableViewCell")
        GetCustomerCardsAPI()
        if PaymentMode == "MakePayment"{
            btnSave.isHidden = true
            btnAddPayment.isHidden = true
            btnAddPaymetTop.constant = 20
            self.btnBackProfile.setTitle("Back To Dispute", for: .normal)
            lblManagepayment.text = "Select card for make payment"


        }else{
               self.btnBackProfile.setTitle("Back_To_Profile".localized(), for: .normal)
               lblManagepayment.text = "Manage_Payment_Method".localized()

        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCardAction), name: NSNotification.Name(rawValue: "Add_Card"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.GetCustomerCardsAPI()
    }
    
    @objc func setText(){
//        self.title = "My_Jobs".localized()
     //   self.btnBackProfile.setTitle("Back_To_Profile".localized(), for: .normal)
        self.btnSave.setTitle("Save".localized(), for: .normal)
        self.btnAddPayment.setTitle("Add_Payment_Method".localized(), for: .normal)

    }
    
    @objc func getCardAction(_ notification: NSNotification) {
        
        if (notification.userInfo?["status"] as? Bool) != nil {
            self.GetCustomerCardsAPI()
        }
    }
    
    func GetCustomerCardsAPI(){
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "GetCustomerCards?UserId=\(appDelegate.user_ID)") { (responce) in
            if responce["message"].stringValue == "success"{
                self.data = responce["data"].arrayValue
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }


    @IBAction func btnSave(_ sender: UIButton) {
    }
    
    @IBAction func btnAddPayment(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPaymentViewController") as! AddPaymentViewController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditPaymentViewController : UITableViewDelegate, UITableViewDataSource, EditPaymentCellDelegate{
    
    func editCardDetail(index: Int) {
        cardIndex = index
        cardNumber = "**** **** **** \(data[index]["CardNumber"].stringValue)"
        DeleteCardAlert()
    }
    
    func DeleteCardAlert() {
        let alert = UIAlertController(title: "Are you sure you want to delete this card ?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.deleteCardApi()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))

        self.present(alert, animated: true)

    }
    
    func deleteCardApi(){
        let apiController : APIController = APIController()
        apiController.postRequest(methodName: "DeleteCard?CardId=\(data[cardIndex]["Id"].intValue)") { (responce) in
            if responce["message"].stringValue == "success"{
                DispatchQueue.main.async {
                    self.GetCustomerCardsAPI()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 {
            self.tblView.setEmptyMessage("No card Found.")
        } else {
            self.tblView.restore()
        }
        
        return data.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditPaymentTableViewCell", for: indexPath) as! EditPaymentTableViewCell
        cell.lblCardName.text = data[indexPath.row]["CardType"].stringValue
        cell.lblCardType.text = "card"
        cell.parentVC = self
        cell.delegate = self
        cell.lblCardNumber.text = "**** **** **** \(data[indexPath.row]["CardNumber"].stringValue)"
        cell.lblExpire.text =  "Expires \(data[indexPath.row]["ExpiryMonth"].stringValue)/\(data[indexPath.row]["ExpiryYear"].stringValue.dropFirst(2))"
         print(data[indexPath.item]["CardType"].stringValue)
        if data[indexPath.item]["CardType"].stringValue == "Discover" {
            cell.iconCard.image = UIImage(named: "ic_discover")
        }
        else if data[indexPath.item]["CardType"].stringValue == "Visa"{
            cell.iconCard.image = UIImage(named: "ic_visa")
        }
        else if data[indexPath.item]["CardType"].stringValue == "MasterCard"{
            cell.iconCard.image = UIImage(named: "ic_mastercard")
        }
        else if data[indexPath.item]["CardType"].stringValue == "American Express"{
                   cell.iconCard.image = UIImage(named: "ic_amex")
        }
        else{
            cell.iconCard.image = #imageLiteral(resourceName: "noimage")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action:UITableViewRowAction, indexPath:IndexPath) in
//            print("delete at:\(indexPath)")
//        }
//        delete.backgroundColor = .red
//
//        let more = UITableViewRowAction(style: .default, title: "Edit") { (action:UITableViewRowAction, indexPath:IndexPath) in
//            print("more at:\(indexPath)")
//        }
//        more.backgroundColor = .orange
//
//        return [delete, more]
//    }

}


//
//  EditPaymentTableViewCell.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 28/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class EditPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblExpire: UILabel!
    @IBOutlet weak var iconCard: UIImageView!
    @IBOutlet weak var lblCardType: UILabel!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var btnEdit: UIButton!

    let constant : CommonStrings = CommonStrings.commonStrings
    
    var delegate : EditPaymentCellDelegate! = nil
    var parentVC = EditPaymentViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.cellBGViewShdow()
//        btnEdit.setImage(#imageLiteral(resourceName: "PaymentMethod-delete").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
//        btnEdit.tintColor = constant.theamGreenColor
        
        //---------------------------------This Code is Updated------------------------------------
        if traitCollection.userInterfaceStyle == .dark{

            lblExpire.textColor = UIColor.white
            lblCardType.textColor = UIColor.white
            lblCardNumber.textColor = UIColor.white
            
             bgView.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25).cgColor
             bgView.backgroundColor = UIColor.black
            // BGView.layer.shadowColor = UIColor(white: 0, alpha: 0.25).cgColor
             bgView.layer.shadowOffset = CGSize(width: 0, height: 3)
             bgView.layer.shadowOpacity = 1.0
             bgView.layer.shadowRadius = 5.0
             bgView.layer.masksToBounds = false

        }else if(traitCollection.userInterfaceStyle == .light){

            lblExpire.textColor = UIColor.black
            lblCardType.textColor = UIColor.black
            lblCardNumber.textColor = UIColor.black
            
            bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
             bgView.backgroundColor = UIColor.white
             bgView.layer.shadowOffset = CGSize(width: 0, height: 3)
             bgView.layer.shadowOpacity = 1.0
             bgView.layer.shadowRadius = 5.0
             bgView.layer.masksToBounds = false

        }else if(traitCollection.userInterfaceStyle == .unspecified){
            
            lblExpire.textColor = UIColor.black
            lblCardType.textColor = UIColor.black
            lblCardNumber.textColor = UIColor.black
            
            bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
             bgView.backgroundColor = UIColor.white
             bgView.layer.shadowOffset = CGSize(width: 0, height: 3)
             bgView.layer.shadowOpacity = 1.0
             bgView.layer.shadowRadius = 5.0
             bgView.layer.masksToBounds = false
            
        }
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        let index = parentVC.tblView.indexPath(for: self)
        let row : Int = index?.row ?? 0
        delegate.editCardDetail(index: row)
    }
    
}

protocol EditPaymentCellDelegate{
    func editCardDetail(index:Int)
}

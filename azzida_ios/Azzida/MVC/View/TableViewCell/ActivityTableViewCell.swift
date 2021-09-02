//
//  ActivityTableViewCell.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 27/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var BGView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        

        
        
       if self.traitCollection.userInterfaceStyle == .dark{
            lblName.textColor = UIColor.white
            lblDetail.textColor = UIColor.white
        
        BGView.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25).cgColor
        BGView.backgroundColor = UIColor.black
       // BGView.layer.shadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        BGView.layer.shadowOffset = CGSize(width: 0, height: 3)
        BGView.layer.shadowOpacity = 1.0
        BGView.layer.shadowRadius = 5.0
        BGView.layer.masksToBounds = false
        
            
        
        }
       
        if self.traitCollection.userInterfaceStyle == .light{
            lblName.textColor = UIColor.black
            lblDetail.textColor = UIColor.black
            
            BGView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            BGView.backgroundColor = UIColor.white
            BGView.layer.shadowOffset = CGSize(width: 0, height: 3)
            BGView.layer.shadowOpacity = 1.0
            BGView.layer.shadowRadius = 5.0
            BGView.layer.masksToBounds = false
        }
        
        if self.traitCollection.userInterfaceStyle == .unspecified{
            lblName.textColor = UIColor.black
            lblDetail.textColor = UIColor.black
            
            BGView.backgroundColor = UIColor.white
            BGView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            BGView.layer.shadowOffset = CGSize(width: 0, height: 3)
            BGView.layer.shadowOpacity = 1.0
            BGView.layer.shadowRadius = 5.0
            BGView.layer.masksToBounds = false
        }
        
        
//        switch traitCollection.userInterfaceStyle {
//        case .light:
//            lblName.textColor = UIColor.black
//            lblDetail.textColor = UIColor.black
//            break
//            
//        case .dark:
//            lblName.textColor = UIColor.black
//            lblDetail.textColor = UIColor.white
//            break
//            
//        case .unspecified:
//            lblName.textColor = UIColor.white
//            lblDetail.textColor = UIColor.white
//            break
//        }
        
        
        
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

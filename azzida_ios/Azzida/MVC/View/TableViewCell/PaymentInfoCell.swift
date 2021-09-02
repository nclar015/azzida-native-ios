//
//  PaymentInfoCell.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 28/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class PaymentInfoCell: UITableViewCell {
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblprice: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var bgView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //bgView.cellBGViewShdow()
        
        if(traitCollection.userInterfaceStyle == .dark){
            
             bgView.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25).cgColor
//             bgView.backgroundColor = UIColor.black
            // BGView.layer.shadowColor = UIColor(white: 0, alpha: 0.25).cgColor
             bgView.layer.shadowOffset = CGSize(width: 0, height: 3)
             bgView.layer.shadowOpacity = 1.0
             bgView.layer.shadowRadius = 5.0
             bgView.layer.masksToBounds = false
            
        }else if(traitCollection.userInterfaceStyle == .light){
            
            bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//            bgView.backgroundColor = UIColor.white
            bgView.layer.shadowOffset = CGSize(width: 0, height: 3)
            bgView.layer.shadowOpacity = 1.0
            bgView.layer.shadowRadius = 5.0
            bgView.layer.masksToBounds = false
            
        }else if(traitCollection.userInterfaceStyle == .unspecified){
            
            bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//            bgView.backgroundColor = UIColor.white
            bgView.layer.shadowOffset = CGSize(width: 0, height: 3)
            bgView.layer.shadowOpacity = 1.0
            bgView.layer.shadowRadius = 5.0
            bgView.layer.masksToBounds = false
            
        }
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}


extension UIView{
    func cellBGViewShdow(){
        
        if(traitCollection.userInterfaceStyle == .dark){
            
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25).cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 5.0
            

        }else if(traitCollection.userInterfaceStyle == .light){
            
            self.clipsToBounds = false
            self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 5.0
            self.layer.masksToBounds = false
            
            
        }else if(traitCollection.userInterfaceStyle == .unspecified){
            
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 5.0
            
            
        }
        
        
//        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 3)
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius = 5.0
//        self.layer.masksToBounds = false
        
        }

}

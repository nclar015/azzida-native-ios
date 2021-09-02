//
//  JobsListTableViewCell.swift
//  Azzida
//
//  Created by iVishnu on 22/07/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class JobsListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var BGView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        BGView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        BGView.layer.shadowOffset = CGSize(width: 0, height: 3)
        BGView.layer.shadowOpacity = 1.0
        BGView.layer.shadowRadius = 5.0
        BGView.layer.masksToBounds = false
        
        if(traitCollection.userInterfaceStyle == .dark){
            
            BGView.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25).cgColor
            BGView.backgroundColor = UIColor.black
            BGView.layer.shadowOffset = CGSize(width: 0, height: 3)
            BGView.layer.shadowOpacity = 1.0
            BGView.layer.shadowRadius = 5.0
            BGView.layer.masksToBounds = false
            
        }else if(traitCollection.userInterfaceStyle == .light){
            
            BGView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            BGView.backgroundColor = UIColor.white
            BGView.layer.shadowOffset = CGSize(width: 0, height: 3)
            BGView.layer.shadowOpacity = 1.0
            BGView.layer.shadowRadius = 5.0
            BGView.layer.masksToBounds = false
            
        }else if(traitCollection.userInterfaceStyle == .unspecified){
            
            BGView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            BGView.backgroundColor = UIColor.white
            BGView.layer.shadowOffset = CGSize(width: 0, height: 3)
            BGView.layer.shadowOpacity = 1.0
            BGView.layer.shadowRadius = 5.0
            BGView.layer.masksToBounds = false
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

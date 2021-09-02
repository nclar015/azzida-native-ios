//
//  SideMenuTableViewCell.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 27/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMenu : UILabel!
    @IBOutlet weak var iconMenu : UIImageView!
    @IBOutlet weak var lineView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.traitCollection.userInterfaceStyle == .dark{
            lblMenu.textColor = UIColor.white
            iconMenu.tintColor = UIColor.white
        }else{
            lblMenu.textColor = UIColor.black
            iconMenu.tintColor = UIColor.black
            
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

class SideMenuFollowViewCell: UITableViewCell {
    @IBOutlet weak var imgInsta : UIImageView!
    @IBOutlet weak var imgFacebook : UIImageView!
    @IBOutlet weak var imgTwitter : UIImageView!

    override func awakeFromNib() {
          super.awakeFromNib()
        
      }
}



//
//  ProfileMenuViewCell.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 27/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

protocol ProfileMenuDelegate {
    func menuTag(index:Int)
}

class ProfileMenuViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnMenu : UIButton!
    
    var indexPath : NSIndexPath!
    var parentVC : MyProfileViewController!
    var delegate : ProfileMenuDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnMenu.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnMenu.layer.shadowOffset = CGSize(width: 0, height: 3)
        btnMenu.layer.shadowOpacity = 1.0
        btnMenu.layer.shadowRadius = 5.0
        btnMenu.layer.masksToBounds = false
        
        btnMenu.titleLabel?.textAlignment = .center
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        indexPath = parentVC.menuCollectionView.indexPath(for: self) as NSIndexPath?
        delegate.menuTag(index:indexPath.item)
    }
    
    
    
    
}

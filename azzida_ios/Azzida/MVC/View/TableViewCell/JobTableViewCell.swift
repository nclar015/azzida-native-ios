//
//  JobTableViewCell.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 29/05/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import SDWebImage
class JobTableViewCell: UITableViewCell {
    
    @IBOutlet weak var BGview: UIView!
    @IBOutlet weak var btnDistance: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var lblJobStatus: UILabel!
    
    var viewDotColor : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        roundView.cellBGViewShdow()
        
//        viewDot.roundCorners(corners: UIRectCorner.allCorners, radius: 8)
//        viewDot.clipsToBounds = true
        
        
        if traitCollection.userInterfaceStyle == .dark{
            lblTitle.textColor = UIColor.white
            btnDistance.setTitleColor(UIColor.white, for: .normal)
            btnDate.setTitleColor(UIColor.white, for: .normal)
        }else if(traitCollection.userInterfaceStyle == .light){
            lblTitle.textColor = UIColor.black
            btnDistance.setTitleColor(UIColor.black, for: .normal)
            btnDate.setTitleColor(UIColor.black, for: .normal)
        }else if(traitCollection.userInterfaceStyle == .unspecified){
            lblTitle.textColor = UIColor.black
            btnDistance.setTitleColor(UIColor.black, for: .normal)
            btnDate.setTitleColor(UIColor.black, for: .normal)
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForground(notification:)), name: Notification.Name("WillEnterForground"), object: nil)
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        
        
    }
    
    @IBAction func btnDate(_ sender: UIButton) {
        
    }
    
    @IBAction func btnDistance(_ sender: UIButton) {
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if(traitCollection.userInterfaceStyle == .dark){
            // set your Dark UI
            self.self.lblTitle.textColor = UIColor.white
            self.btnDistance.setTitleColor(UIColor.white, for: .normal)
            self.btnDate.setTitleColor(UIColor.white, for: .normal)
        } else {
            // set your Light UI
            self.lblTitle.textColor = UIColor.black
            self.btnDistance.setTitleColor(UIColor.black, for: .normal)
            self.btnDate.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
//    @objc func willEnterForground(notification:Notification) {
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//            if self.traitCollection.userInterfaceStyle == .dark{
//
//            }else if(self.traitCollection.userInterfaceStyle == .light){
//                self.lblTitle.textColor = UIColor.black
//                self.btnDistance.setTitleColor(UIColor.black, for: .normal)
//                self.btnDate.setTitleColor(UIColor.black, for: .normal)
//            }else if(self.traitCollection.userInterfaceStyle == .unspecified){
//                self.lblTitle.textColor = UIColor.black
//                self.btnDistance.setTitleColor(UIColor.black, for: .normal)
//                self.btnDate.setTitleColor(UIColor.black, for: .normal)
//            }
//        }
//    }
    
}

//
//  MessageSendCell.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 10/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class MessageSendCell: UITableViewCell {
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var userImg : UIImageView!
    @IBOutlet weak var lblDate : UILabel!

    
    let constant : CommonStrings = CommonStrings.commonStrings

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.image = imgView.image?.maskWithColor(color: constant.theamColor)
            .resizableImage(withCapInsets:
                                UIEdgeInsets(top: 51, left: 64, bottom: 51, right: 64),
                            resizingMode: .stretch)
//            .withRenderingMode(.alwaysTemplate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}


extension UIImage {

     func maskWithColor(color: UIColor) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        let rect = CGRect(origin: CGPoint.zero, size: size)

        color.setFill()
        self.draw(in: rect)

        context.setBlendMode(.sourceIn)
        context.fill(rect)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }

}

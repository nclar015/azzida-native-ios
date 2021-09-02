//
//  ReceiveMessageCell.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 10/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class ReceiveMessageCell: UITableViewCell {
    
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var userImg : UIImageView!
    @IBOutlet weak var lblDate : UILabel!


    let constant : CommonStrings = CommonStrings.commonStrings

    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.image = imgView.image?.maskWithColor(color: constant.theamGreenColor)
            .resizableImage(withCapInsets:
                                UIEdgeInsets(top: 51, left: 64, bottom: 51, right: 64),
                            resizingMode: .stretch)
//            .withRenderingMode(.alwaysTemplate)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

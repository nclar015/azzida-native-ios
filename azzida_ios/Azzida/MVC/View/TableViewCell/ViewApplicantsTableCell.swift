//
//  ViewApplicantsTableCell.swift
//  Azzida
//
//  Created by Vishnu Chhipa on 05/06/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

class ViewApplicantsTableCell: UITableViewCell {

    @IBOutlet weak var BGview: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imgView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        BGview.cellBGViewShdow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

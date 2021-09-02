//
//  AddImageCollectionViewCell.swift
//  Azzida
//
//  Created by iVishnu on 14/07/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

protocol AddImageDelegate {
    func setImage(index:Int, parentview: UIView)
}

import UIKit

class AddImageCollectionViewCell: UICollectionViewCell {
    
    var delegate : AddImageDelegate! = nil
    var parentVC = AddJobViewController()
    let viewDemo = UIView()
//    var customView = MyCustomView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//    let customView = MyCustomView(frame: )
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var btnCamera : UIButton!
    @IBOutlet weak var btnAddPhoto : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewDemo.frame = CGRect(x: 100, y: 200, width: 100, height: 100)
        imgView.contentMode = .scaleAspectFill
    }
    
    @IBAction func btnCamera(_ sender: UIButton) {
        delegate.setImage(index: parentVC.imgCollection.indexPath(for: self)?.row ?? 0, parentview: viewDemo)
        
    }
    @IBAction func btnAddPhoto(_ sender: UIButton) {
        delegate.setImage(index: parentVC.imgCollection.indexPath(for: self)?.row ?? 0, parentview: viewDemo)

    }
}

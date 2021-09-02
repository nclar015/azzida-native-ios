//
//  Utility.swift
//  Azzida
//
//  Created by iVishnu on 17/07/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import Foundation
import UIKit

class ShowLabel : NSObject{
    class func showlabel(view:UIView,text:String)->UILabel{
        var label = UILabel()
        label = UILabel(frame: CGRect(x: 0, y: view.frame.size.height/2 - 50, width: view.frame.width, height: 100))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = text
        return label
        
    }
    class func removeLabel(label:UILabel){
        label.removeFromSuperview()
    }
}

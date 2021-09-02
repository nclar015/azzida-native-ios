//
//  CustomTextField.swift
//  TentWalas
//
//  Created by Vishnu Chhipa on 30/03/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField,UITextFieldDelegate {
    
    @IBOutlet weak var validationLabel:CustomLabel!
    var placeholdertext: String?
    @IBInspectable
     var cornerRadius :CGFloat {
        
        set { layer.cornerRadius = newValue }
        
        get {
            return layer.cornerRadius
        }
        
    }
    @IBInspectable var borderWidth: CGFloat = 0{
          didSet{
              self.layer.borderWidth = borderWidth
          }
      }
      
      @IBInspectable var borderColor: UIColor = UIColor.clear{
          didSet{
              self.layer.borderColor = borderColor.cgColor
          }
      }
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isUnderLine:Bool = false
        {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    var errorLable:CustomLabel = CustomLabel()
    func setError(_ error:String?){
        if(error != nil)
        {
            if(validationLabel == nil)
            {
                self.attributedPlaceholder = NSAttributedString(string: error!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            else
            {
                validationLabel.text = error!
                validationLabel.textColor = UIColor.red
                validationLabel.leftImage = #imageLiteral(resourceName: "alert")
                self.delegate = self
                //let heightConstraint = validationLabel.heightAnchor.constraint(equalToConstant: 23)
                //NSLayoutConstraint.activate([heightConstraint])
                for constraint in validationLabel.constraints {
                    if(constraint.firstAttribute == NSLayoutConstraint.Attribute.height)
                    {
                        
                        validationLabel.alpha = 0.5
                        self.validationLabel.center.y = self.validationLabel.center.y-25
                        constraint.constant = 25
                        UIView.animate(withDuration: 0.5,
                                       delay: 0.0,
                                       options: UIView.AnimationOptions.transitionCurlDown,
                                       animations: { () -> Void in
                                        self.validationLabel.alpha = 1.0
                                        self.validationLabel.center.y = self.validationLabel.center.y + 25
                                        
                        }, completion: { (finished) -> Void in
                            if(finished)
                            {
                            }
                        })
                        
                    }
                }
            }
            
        }
        
    }
    
    @IBInspectable var isCopyOption: Bool = true
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if(isCopyOption)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var textLeftPadding:CGFloat = 0
    @IBInspectable var textRightPadding:CGFloat = 0
    let underline:UIView = UIView()
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var underlineColor:UIColor = UIColor.black
        {
        didSet{
            self.updateView()
        }
    }
    fileprivate var placeholderColorValue:UIColor = UIColor.lightGray
//    @IBInspectable open var placeholderColor:UIColor
//        {
//        set{
//
//            self.attributedPlaceholder = NSAttributedString(string:placeholdertext!, attributes: [NSAttributedString.Key.foregroundColor: newValue])
//            placeholderColorValue = newValue
//        }
//        get{
//            return placeholderColorValue
//        }
    
    @IBInspectable var placeHolderColor: UIColor? {
        
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
        get {
            return self.placeHolderColor
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    func setUpView() {
        if(rightImage != nil)
        {
            self.rightViewMode = UITextField.ViewMode.always
            let rightImageView:UIImageView = UIImageView(image: rightImage)
            rightImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 10)
            //rightImageView.contentMode = .center
            self.rightView = rightImageView
        }
        else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        underline.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1)
    }
    
    func updateView() {
        setLeftImage()
        setRightImage()
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
        if(self.isUnderLine)
        {
            underline.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1)
            underline.backgroundColor = underlineColor
            self.addSubview(underline)
        }
        if(self.isSecureTextEntry)
        {
            let btnEye:UIButton = UIButton(type:.custom)
            btnEye.addTarget(self, action: #selector(handleEyeTap(_:)), for: UIControl.Event.touchUpInside)
            btnEye.setImage(#imageLiteral(resourceName: "eye"), for: UIControl.State.normal)
            btnEye.frame = CGRect(x: self.frame.width-self.frame.size.height, y: self.frame.origin.y, width: self.frame.size.height, height: self.frame.size.height)
            self.superview!.addSubview(btnEye)
        }
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: textLeftPadding, y: 0, width: bounds.width - textRightPadding, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(validationLabel != nil && validationLabel.alpha > 0.0)
        {
            for constraint in validationLabel.constraints {
                if(constraint.firstAttribute == NSLayoutConstraint.Attribute.height)
                {
                    validationLabel.alpha = 0.5
                    UIView.animate(withDuration: 0.5,
                                   delay: 0.0,
                                   options: UIView.AnimationOptions.transitionCurlDown,
                                   animations: { () -> Void in
                                    self.validationLabel.alpha = 0.0
                                    self.validationLabel.center.y = self.validationLabel.center.y - 25
                                    
                    }, completion: { (finished) -> Void in
                        if(finished)
                        {
                            constraint.constant = 0
                        }
                    })
                }
            }
        }
    }
    
    func setRightImage() {
        if let imageRight = rightImage {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = imageRight
            imageView.contentMode  = .scaleToFill
            imageView.clipsToBounds = true
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            rightView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
    
    func setLeftImage() {
        if let imageLeft = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imageView.image = imageLeft
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
    
    // function which is triggered when handleTap is called
    @objc func handleEyeTap(_ sender: UIButton) {
        self.isSecureTextEntry = !isSecureTextEntry
    }
    
}

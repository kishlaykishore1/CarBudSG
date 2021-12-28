//
//  TextField.swift
//  SweetLifePartner
//
//  Created by angrej singh on 18/11/19.
//  Copyright © 2019 com.tp.sweetlifepartner. All rights reserved.
//

import UIKit
@IBDesignable
class UnderLineImageTextField: UITextField {
    override func draw(_ rect: CGRect) {
        
        let borderLayer = CALayer()
        let widthOfBorder = getBorderWidht()
        borderLayer.frame = CGRect(x: -15, y: self.frame.size.height - widthOfBorder, width: self.frame.size.width+20, height: self.frame.size.height)
        borderLayer.borderWidth = widthOfBorder
        borderLayer.borderColor = getBottomLineColor()
        self.layer.addSublayer(borderLayer)
        self.layer.masksToBounds = true
        
    }
    
    
    
    //MARK : set the image LeftSide
    @IBInspectable var SideImage:UIImage? {
        didSet{
            
            let leftAddView = UIView.init(frame: CGRect(x: 0, y: 0, width: 25, height: self.frame.size.height-10))
            let leftimageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))//Create a imageView for left side.
            leftimageView.image = SideImage
            leftAddView.addSubview(leftimageView)
            self.rightView = leftAddView
            self.rightViewMode = UITextField.ViewMode.always
        }
        
    }
    
//    @IBInspectable var bottomLineColor: UIColor = UIColor.black {
//        didSet {
//            
//        }
//    }
    
    
    func getBottomLineColor() -> CGColor {
        return bottomLineColor.cgColor
        
    }
    @IBInspectable var cusborderWidth:CGFloat = 1.0
        {
        didSet{
            
        }
    }
    
    func getBorderWidht() -> CGFloat {
        return cusborderWidth;
        
    }
}


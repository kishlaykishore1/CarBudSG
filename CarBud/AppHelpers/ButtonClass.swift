
import UIKit

//
//MARK: LEFT BUTTON CORNER RADIUS
//
class LeftButton : UIButton {

    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topLeft, .topRight, .bottomRight], radius: 15.0)
    }
}

//
//MARK: RIGHT BUTTON CORNER RADIUS
//
class RightButton : UIButton {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topLeft, .topRight, .bottomLeft], radius: 15.0)
    }
}

//
//MARK: RIGHT BUTTON CORNER RADIUS
//
class LeftRightButton : UIButton {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.bottomLeft, .bottomRight], radius: 10.0)
    }
}

//
//MARK: LEFT BOTTOM LABEL CORNER RADIUS
//
class LeftBottomLabel : UILabel{
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.bottomLeft], radius: 10.0)
    }
}

//
//MARK: LEFT BOTTOM LABEL CORNER RADIUS
//
class LeftBottomTopRightRadius : UILabel{
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topRight,.bottomLeft], radius: 10.0)
    }
}

//MARK: MARK CORNER RADIUS
extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

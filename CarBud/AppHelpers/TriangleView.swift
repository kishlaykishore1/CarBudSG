import UIKit

@IBDesignable class TriangleView: UIView {
    
    @IBInspectable var color: UIColor = .red
    @IBInspectable var firstPointX: CGFloat = 0
    @IBInspectable var firstPointY: CGFloat = 0
    @IBInspectable var secondPointX: CGFloat = 1
    @IBInspectable var secondPointY: CGFloat = 0.5
    @IBInspectable var thirdPointX: CGFloat = 0
    @IBInspectable var thirdPointY: CGFloat = 1

    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: self.firstPointX * rect.width, y: self.firstPointY * rect.height))
        aPath.addLine(to: CGPoint(x: self.secondPointX * rect.width, y: self.secondPointY * rect.height))
        aPath.addLine(to: CGPoint(x: self.thirdPointX * rect.width, y: self.thirdPointY * rect.height))
        aPath.close()
        self.color.set()
        self.backgroundColor = .clear
        aPath.fill()
    }

}

@IBDesignable class PentagonView: UIView {
    
    @IBInspectable var color: UIColor = .red
    @IBInspectable var firstPointX: CGFloat = 0
    @IBInspectable var firstPointY: CGFloat = 0
    @IBInspectable var secondPointX: CGFloat = 1
    @IBInspectable var secondPointY: CGFloat = 0
    @IBInspectable var thirdPointX: CGFloat = 1
    @IBInspectable var thirdPointY: CGFloat = 7
    @IBInspectable var fouthPointX: CGFloat = 1
    @IBInspectable var fouthPointY: CGFloat = -7
    @IBInspectable var fifthPointX: CGFloat = 0
    @IBInspectable var fifthPointY: CGFloat = 1
    @IBInspectable var sixPointX: CGFloat = 1
    @IBInspectable var sixPointY: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: self.firstPointX * rect.width, y: self.firstPointY * rect.height))
        aPath.addLine(to: CGPoint(x: self.secondPointX * rect.width, y: self.secondPointY * rect.height))
        aPath.addLine(to: CGPoint(x: self.thirdPointX * rect.width, y: (self.thirdPointY * rect.height)))
        aPath.move(to: CGPoint(x: self.fouthPointX * rect.width, y: self.fouthPointY * rect.height))
        aPath.addLine(to: CGPoint(x: self.fifthPointX * rect.width, y: self.fifthPointY * rect.height))
        aPath.addLine(to: CGPoint(x: self.sixPointX * rect.width, y: self.sixPointY * rect.height))
        aPath.move(to: CGPoint(x: self.fouthPointX * rect.width, y: self.fouthPointY * rect.height))
        aPath.addLine(to: CGPoint(x: self.fifthPointX * rect.width, y: self.fifthPointY * rect.height))
        aPath.addLine(to: CGPoint(x: self.sixPointX * rect.width, y: self.sixPointY * rect.height))
        aPath.close()
        self.color.set()
        aPath.fill()
    }
    
}

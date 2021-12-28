//
//  UIViewController.swift
//

import UIKit

extension UIViewController {
    
    public func setNavigationBarImage(for image: UIImage? = nil, color: UIColor = .black) {

        if let image = image {
              self.navigationController?.navigationBar.shadowImage = image
              self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        }else{
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        }
      
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21), NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.isTranslucent = true
    }
    //MARK: NavBar Gradient
    public func setNavigationbarThemeGradientColor(){
        var colors = [UIColor]()
        let leftColor = #colorLiteral(red: 0.137254902, green: 0.2, blue: 0.2431372549, alpha: 1)
        let rightColor = #colorLiteral(red: 0.137254902, green: 0.2, blue: 0.2431372549, alpha: 1)
        colors.append(leftColor)
        colors.append(rightColor)
        colors.append(#colorLiteral(red: 0.137254902, green: 0.2, blue: 0.2431372549, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
    }
    
    //MARK: BackButton
    public func setBackButton(tintColor: UIColor = .white, isImage: Bool = false) {
        let btn1 = UIButton(type: .custom)
        if isImage {
            btn1.setImage(#imageLiteral(resourceName: "Icon_Back").imageWithColor(color: tintColor), for: .normal)
            btn1.imageView?.contentMode = .scaleAspectFit
            btn1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        } else {
            btn1.setTitle("Back", for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        }
        btn1.contentHorizontalAlignment = .left
        btn1.setTitleColor(tintColor, for: .normal)
        btn1.addTarget(self, action: #selector(self.backBtnTapAction), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        let negativeSpacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [negativeSpacer, item1]
    }
    
    //MARK: Like Button
    public func setRightButton(tintColor: UIColor = .white, image: UIImage =  #imageLiteral(resourceName: "back") , isImage: Bool = false, txt: String = "Valider"){
        let btn1 = UIButton(type: .custom)
//        btn1.setImage(#imageLiteral(resourceName: "like2"), for: .normal)
//        btn1.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
//        btn1.imageView?.contentMode = .scaleAspectFit
//        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if isImage {
            btn1.setImage(image, for: .normal)
            btn1.imageView?.contentMode = .scaleAspectFit
            btn1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        } else {
            btn1.setTitle(txt, for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
            btn1.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 16)
        }
        btn1.setTitleColor(tintColor, for: .normal)
        btn1.addTarget(self, action: #selector(self.rightBtnTapAction(sender:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButton(item1, animated: true)
    }
    
    @objc func rightBtnTapAction(sender: UIButton){}
    
    @objc func backBtnTapAction(){}
    
    
//    public func setBlueGradientColor(){
//        let leftColor = UIColor(red: 69/255, green: 45/255, blue: 179/255, alpha: 1)
//        let rightColor = UIColor(red: 200/255, green: 109/255, blue: 215/255, alpha: 1)
//        self.view.applyGradient(withColours: [leftColor,rightColor], gradientOrientation: .horizontal)
//    }
//
//    public func setYellowGradientColor(){
//        let leftColor = UIColor(red: 247/255, green: 107/255, blue: 28/255, alpha: 1)
//        let rightColor = UIColor(red: 255/255, green: 200/255, blue: 0/255, alpha: 1)
//        self.view.applyGradient(withColours: [leftColor,rightColor], gradientOrientation: .horizontal)
//    }
    
 //   public func setTutorialGradientColor() {
//        let topColor = #colorLiteral(red: 0.4352941176, green: 0.7450980392, blue: 0.7960784314, alpha: 1)
//        let bottomColor = #colorLiteral(red: 0.2352941176, green: 0.537254902, blue: 0.6078431373, alpha: 1)
//        self.view.applyGradient(withColours: [topColor,bottomColor], gradientOrientation: .vertical)
 //   }
    
//    public func setNavigationbarYellowGradientColor(){
//        var colors = [UIColor]()
//        let leftColor = UIColor(red: 247/255, green: 107/255, blue: 28/255, alpha: 1)
//        let rightColor = UIColor(red: 255/255, green: 200/255, blue: 0/255, alpha: 1)
//        colors.append(leftColor)
//        colors.append(rightColor)
//        navigationController?.navigationBar.setGradientBackground(colors: colors)
//    }
//
//    public func setNavigationbarRedGradientColor(){
//        var colors = [UIColor]()
//        let leftColor = UIColor(red: 255/255, green: 0/255, blue: 23/255, alpha: 1)
//        let rightColor = UIColor(red: 159/255, green: 4/255, blue: 27/255, alpha: 1)
//        colors.append(leftColor)
//        colors.append(rightColor)
//        navigationController?.navigationBar.setGradientBackground(colors: colors)
//    }
    
}


extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func createGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        let getLayer = self.getGradientLayer(withColours: colors, gradientOrientation: .horizontal)
        
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
       // let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        setBackgroundImage(getLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}




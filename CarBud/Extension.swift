//
//  Extension.swift
//  InstaHastag
//
//  Created by Snow-Macmini-1 on 03/05/19.
//  Copyright © 2019 Snow-Macmini-1. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import GoogleMaps
public var selectedTitle = String()


extension Double {
    var dollarString:String {
        return String(format: "$%.2f", self)
    }
}

extension UIColor {
    
    convenience init(r: UInt8, g: UInt8, b: UInt8, alpha: CGFloat = 1.0) {
        let divider: CGFloat = 255.0
        self.init(red: CGFloat(r)/divider, green: CGFloat(g)/divider, blue: CGFloat(b)/divider, alpha: alpha)
    }
    
    private convenience init(rgbWithoutValidation value: Int32, alpha: CGFloat = 1.0) {
        self.init(
            r: UInt8((value & 0xFF0000) >> 16),
            g: UInt8((value & 0x00FF00) >> 8),
            b: UInt8(value & 0x0000FF),
            alpha: alpha
        )
    }
    
    convenience init?(rgb: Int32, alpha: CGFloat = 1.0) {
        if rgb > 0xFFFFFF || rgb < 0 { return nil }
        self.init(rgbWithoutValidation: rgb, alpha: alpha)
    }
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var charSet = CharacterSet.whitespacesAndNewlines
        charSet.insert("#")
        let _hex = hex.trimmingCharacters(in: charSet)
        guard _hex.range(of: "^[0-9A-Fa-f]{6}$", options: .regularExpression) != nil else { return nil }
        var rgb: UInt32 = 0
        Scanner(string: _hex).scanHexInt32(&rgb)
        self.init(rgbWithoutValidation: Int32(rgb), alpha: alpha)
    }
}

//extension UIApplication {
//    var statusBarView: UIView? {
//        if responds(to: Selector(("statusBar"))) {
//            return value(forKey: "statusBar") as? UIView
//        }
//        return nil
//    }
//}

func GeocoderGetPlaceInfoAutomate(placeName:String,success:@escaping (NSDictionary) -> Void, failure:@escaping (Error) -> Void)  {
    
    let geoCoder = CLGeocoder()
    print(placeName)
    geoCoder.geocodeAddressString(placeName) { (placemarks, error) in
        
        if ((error) != nil)
                {
        
                    failure(error!)
                }
                else
                {
        
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    let coordinates:CLLocationCoordinate2D = placeMark.location!.coordinate
                   
                    let dictInfo = NSMutableDictionary()
                    dictInfo.setValue(coordinates.latitude, forKey: "lat")
                    dictInfo.setValue(coordinates.longitude, forKey: "long")
                
                    success(dictInfo)
            }
       
        }
        
    }



func GeocoderGetPlaceInfo(lat:Double,long:Double,success:@escaping (NSDictionary) -> Void, failure:@escaping (Error) -> Void)  {
    
    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: lat, longitude: long)
    
    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        
        // Place details
        
        if ((error) != nil)
        {
            
            failure(error!)
        }
        else
        {
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            success(placeMark.addressDictionary! as NSDictionary)
            
            
        }
        
    })
}
var window = UIWindow()
//public var googleAPIKey = "AIzaSyCMQ7LsALtTByAwtrghpxu_4AC9sZMOozo"
public var googleAPIKey = "AIzaSyD5bQNjiDTYT5TIOuWwem8vxytcro_2HNE"

var appDelegate = UIApplication.shared.delegate as? AppDelegate


func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
extension UIViewController
{
    func passtoNextVc(IDStr:String)  {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: IDStr)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func MakeToRootVc(IdStr:String)  {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: IdStr)
        window.rootViewController = initialViewController
//        let myTabBar = self.window?.rootViewController as! UITabBarController // Getting Tab Bar
//        myTabBar.selectedIndex = 1
        window.makeKeyAndVisible()
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension UICollectionViewCell
{
   
    func bottomBoarder(color:UIColor)  {
        let bottomLine = CALayer()
        bottomLine.frame  = CGRect(x: 0, y: self.frame.height-4, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
       
    }
}
func showProgressHud(view:UIView)  {

    let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
    loadingNotification?.mode = .indeterminate
    loadingNotification?.color = UIColor .clear
    loadingNotification?.activityIndicatorColor = UIColor.darkGray
}
func dissmissHUD(_ view:UIView)  {

    MBProgressHUD.hideAllHUDs(for: view, animated: true)
}
func timeConversion12(time24: String) -> String {
    let dateAsString = time24
    let df = DateFormatter()
    df.dateFormat = "HH:mm:ss"
    
    let date = df.date(from: dateAsString)
    df.dateFormat = "hh:mm:ssa"
    
    let time12 = df.string(from: date!)
    print(time12)
    return time12
}
func TostErrorMessage(view:UIView,message:String)  {
    var style = ToastStyle()
    style.backgroundColor = UIColor.red
    style.cornerRadius = 5
    view.makeToast( message, duration: 3.0, position: .top,style: style)
}
func SucessMessage(view:UIView,message:String)  {
    var style = ToastStyle()
    // style.backgroundColor = UIColor.red
    style.cornerRadius = 5
    view.makeToast( message, duration: 3.0, position: .top,style: style)
}

func isInterNetConnected() -> Bool {

    let interNetreachable = Reachability .forInternetConnection()

    let networkstatus:NetworkStatus = (interNetreachable?.currentReachabilityStatus())!

    switch networkstatus {

    case NotReachable:

        return false

    case ReachableViaWiFi:

        return true

    case ReachableViaWWAN:

        return true

    default:

        return true

    }
}
extension UIView
{
    func ShadowColorView()  {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
    }
    
    func BoarderOdView()  {
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
    }
    
    func addTopBorder(color: UIColor, thickness: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: thickness)
        addSubview(border)
    }
    
    func viewPopShadow()  {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
    }
    
    
    
    func addDashedBorder() {
        let color = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width,height: width)
        border.opacity = 0.5
        self.layer.addSublayer(border)
    }
    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
extension UIButton
{
    func btnCircle()  {
        
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
    }
    
    func btnCornerRadius(radius:CGFloat)  {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func btnRadiusWithBoarderGreen(radius:CGFloat)  {
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    func btnCircleWithBoarderGaray()  {
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 1
    }
    
    func btnGrayBoarderWithRadius(radius:CGFloat)  {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 1
    }
    
    func btnBlackBoarderWithRadius()  {
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
}
extension UILabel
{
    func lblCornerRadius(radius:CGFloat)  {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
extension UITextField
{
    func textfieldBorader()  {
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setRightImage(imageName:String)  {
        
        let arrow = UIImageView(image: UIImage(named: imageName))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 0.0, height: size.height)
        }
        arrow.contentMode = UIView.ContentMode.center
        self.rightView = arrow
        self.rightViewMode = UITextField.ViewMode.always
        
    }
    
    func setLeftImage(imageName:String)  {
        
        let arrow = UIImageView(image: UIImage(named: imageName))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 10.0, height: size.height)
        }
        arrow.contentMode = UIView.ContentMode.center
        self.leftView = arrow
        self.leftViewMode = UITextField.ViewMode.always
        
    }
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
        
    }
    func textfieldCorner(radius:CGFloat)  {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

extension UISearchBar {
    
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    
    func setClearButton(color: UIColor) {
        getTextField()?.setClearButton(color: color)
    }
}

extension UITextField {
    
    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
    }
    
    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}

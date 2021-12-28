//
//  SideMenuVC.swift
//  CarBud
//
//  Created by kishlay kishore on 24/02/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import UIKit
import StoreKit

class SideMenuVC: UIViewController {
    var menuTiles = ["Feedback","Rate App","Onsite Services","Quotation Request","FAQ","My Profile"]
    var menuTitles = ["Feedback","Rate App","Onsite Services","FAQ","My Profile"]
    var menuImages = [#imageLiteral(resourceName: "feedback_SideMenu"),#imageLiteral(resourceName: "smartphone_SideMenu"),#imageLiteral(resourceName: "SideMenu3"),#imageLiteral(resourceName: "SideMenu4"),#imageLiteral(resourceName: "SideMenu5"),#imageLiteral(resourceName: "SideMenu6")]
    var menuImages1 = [#imageLiteral(resourceName: "feedback_SideMenu"),#imageLiteral(resourceName: "smartphone_SideMenu"),#imageLiteral(resourceName: "SideMenu3"),#imageLiteral(resourceName: "SideMenu5"),#imageLiteral(resourceName: "SideMenu6")]
    var MyIndex = 0
    var quoteReqStatus:Int?

   
    @IBOutlet weak var chargesMarkerView: UIView!
    @IBOutlet weak var lblChargesTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        if UserDefaults.standard.integer(forKey:"serviceCarId") == 2 {
            chargesMarkerView.isHidden = false
            lblChargesTitle.isHidden = false
        } else {
            chargesMarkerView.isHidden = true
            lblChargesTitle.isHidden = true
        }
        
        
        self.navigationController?.navigationBar.isHidden = true
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Parking Charges Colour Coding", attributes: underlineAttribute)
        lblChargesTitle.attributedText = underlineAttributedString
        self.tableView.tableFooterView = UIView()
        
    }
    //MARK:- Review Window Function
    func DisplayReviewController() {
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
        }
    }
    
}

//MARK:- TableView DataSource Method
extension SideMenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if quoteReqStatus == 1 {
               return menuTiles.count
           } else {
            return menuTitles.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell", for: indexPath) as! MenuTableCell
        if quoteReqStatus == 1 {
            cell.imgMenuTiles.image = menuImages[indexPath.row].withRenderingMode(.alwaysTemplate)
            cell.imgMenuTiles.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lblMenuItems.text = menuTiles[indexPath.row]
        } else {
            cell.imgMenuTiles.image = menuImages1[indexPath.row].withRenderingMode(.alwaysTemplate)
            cell.imgMenuTiles.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lblMenuItems.text = menuTitles[indexPath.row]
        }
//            cell.imgMenuTiles.image = menuImages[indexPath.row].withRenderingMode(.alwaysTemplate)
//            cell.imgMenuTiles.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//            cell.lblMenuItems.text = menuTiles[indexPath.row]
            
            let myCustomSelectionColorView = UIView()
            myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1)
            cell.selectedBackgroundView = myCustomSelectionColorView
        
            return cell
       }
}

//MARK:- TableView Delegates Method
extension SideMenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            MyIndex = indexPath.row
        switch MyIndex {
        case 0:
            let strybd = UIStoryboard(name: "Main", bundle: nil)
            let viewController = strybd.instantiateViewController(withIdentifier: "feedbackViewController") as! feedbackViewController
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
           DisplayReviewController()
        case 2:
            let strybd = UIStoryboard(name: "Main", bundle: nil)
            let viewController = strybd.instantiateViewController(withIdentifier: "OnsiteServicesVC") as! OnsiteServicesVC
            navigationController?.pushViewController(viewController, animated: true)
        case 3:
            if quoteReqStatus == 1 {
                let strybd = UIStoryboard(name: "Main", bundle: nil)
                let viewController = strybd.instantiateViewController(withIdentifier: "QuotationReqVC") as! QuotationReqVC
                navigationController?.pushViewController(viewController, animated: true)
            } else {
                let strybd = UIStoryboard(name: "Main", bundle: nil)
                let viewController = strybd.instantiateViewController(withIdentifier: "FAQVC") as! FAQVC
                navigationController?.pushViewController(viewController, animated: true)
            }
            
              
        case 4:
            if quoteReqStatus == 1 {
                let strybd = UIStoryboard(name: "Main", bundle: nil)
                let viewController = strybd.instantiateViewController(withIdentifier: "FAQVC") as! FAQVC
                navigationController?.pushViewController(viewController, animated: true)
            } else {
                let strybd = UIStoryboard(name: "Main", bundle: nil)
                let viewController = strybd.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
                navigationController?.pushViewController(viewController, animated: true)
            }
           
        case 5:
            let strybd = UIStoryboard(name: "Main", bundle: nil)
            let viewController = strybd.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
           
    }
}
//MARK:- Table View Cell class
class MenuTableCell: UITableViewCell {
    
    @IBOutlet weak var imgMenuTiles: UIImageView!
    @IBOutlet weak var lblMenuItems: UILabel!
}

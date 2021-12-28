//
//  FAQVC.swift
//  CarBud
//
//  Created by kishlay kishore on 25/02/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FAQVC: UIViewController {
    
    @IBOutlet weak var btnCollapseAll: UIButton!
    @IBOutlet weak var btnExpandAll: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var FooterView: GADBannerView!
   // @IBOutlet weak var SeperatorLineHeight: NSLayoutConstraint!
    
     var adBannerView: GADBannerView!
     var getFAQData = [FAQModelElement]()
     var orderid = 1
     var storeArr = [Any]()
    
    
    
    //MARK: For Lines Under Button
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 16),
        .foregroundColor: UIColor.orange,
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationbarThemeGradientColor()
        
        FooterView.adUnitID = "ca-app-pub-8501671653071605/1974659335"
        FooterView.rootViewController = self
        let adRequest = GADRequest()
        adRequest.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        FooterView.load(GADRequest())
        
        let attributeString = NSMutableAttributedString(string: "Expand All",
                                                        attributes: yourAttributes)
        let attributeString1 = NSMutableAttributedString(string: "Collapse All",
                                                         attributes: yourAttributes)
        btnExpandAll.setAttributedTitle(attributeString, for: .normal)
        btnCollapseAll.setAttributedTitle(attributeString1, for: .normal)
        footerConfig()
        faqApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        setBackButton(tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , isImage: true)
        title = "FAQ"
    }
    override func backBtnTapAction() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Button Expand All Action
    @IBAction func btnExpandAllPressed(_ sender: UIButton) {
        for index in 0..<getFAQData.count {
            
            getFAQData[index].isExpanded = true
           
        }
        tableView.reloadData()
        
    }
    //MARK:- Button Collapse All Action
    @IBAction func btnCollapseAllPressed(_ sender: UIButton) {
        for index in 0..<getFAQData.count {
            
            getFAQData[index].isExpanded = false
           
            
        }
        tableView.reloadData()
        
    }
    
}
//MARK:- To Set The Footer View Configuration
extension FAQVC {
    func footerConfig() {
        
        FooterView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width , height: FooterView.frame.size.height)
        tableView.tableFooterView = FooterView
        tableView.tableFooterView?.frame = FooterView.frame
    }
}
//MARK:- TableView DataSource Method
extension FAQVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getFAQData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableCell", for: indexPath) as! FAQTableCell
      
        cell.lblAnswerData.text = getFAQData[indexPath.row].answer.htmlToString
        cell.lblQuestionData.text = getFAQData[indexPath.row].question
        cell.imgArrow.image = (getFAQData[indexPath.row].isExpanded ?? false) ? #imageLiteral(resourceName: "angle-arrow-up") : #imageLiteral(resourceName: "angle-arrow-down")
        cell.mainView.backgroundColor = (getFAQData[indexPath.row].isExpanded ?? false) ? #colorLiteral(red: 0.7607843137, green: 0.9411764706, blue: 0.9882352941, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (getFAQData[indexPath.row].isExpanded ?? false) ? UITableView.automaticDimension : 64
    }
}

//MARK:- TableView Delegates Method
extension FAQVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        getFAQData[indexPath.row].isExpanded = !(getFAQData[indexPath.row].isExpanded ?? false)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

//MARK:- Table View Cell Class
class FAQTableCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblQuestionData: UILabel!
    @IBOutlet weak var lblAnswerData: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    
}

//MARK:- APi Calling
extension FAQVC {
    func faqApi()  {
        APIManager().requestGETURL(getFaqDataAPI, success: { (response) in
            print(response)
            let responseDict = response.dictionaryObject
            guard responseDict?["status"] as? Bool ?? false, let getData = responseDict?["data"] as? [[String: Any]] else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                self.getFAQData = try decoder.decode([FAQModelElement].self, from: jsonData)
                print(self.getFAQData)
                self.tableView.reloadData()
                
            } catch {
                
            }
        }) { (error) in
            print(error)
        }
        
    }
}

//MARK:- Google Ads Implementation
extension FAQVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        tableView.tableFooterView?.frame = FooterView.frame
        tableView.tableFooterView = FooterView
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
}

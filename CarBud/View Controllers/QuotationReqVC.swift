//
//  QuotationReqVC.swift
//  CarBud
//
//  Created by kishlay kishore on 27/02/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol YourCellDelegate : class {
    func didPressButton(_ tag: Int)
}

class QuotationReqVC: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var footerView: GADBannerView!
    @IBOutlet weak var lblSupportNumber: UILabel!
    @IBOutlet weak var tableView: UITableView!
   
    var getActiveStatus:Int?
    var adBannerView: GADBannerView!
    var getQuotationReqData = [UsersQuotationModelElement]()
    var userData = Defaults.MemberModel.getMemberModel()
    var getSupportNum = [SupportNumberModelElement]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationbarThemeGradientColor()
      
       footerConfig()
       supportNo()
       footerView.adUnitID = "ca-app-pub-8501671653071605/1974659335"
       footerView.rootViewController = self
       let adRequest = GADRequest()
       adRequest.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
       footerView.load(GADRequest())
      
       
    }
    override func viewWillAppear(_ animated: Bool) {
                  quoteDetails()
                  checkUserStatus()
                  self.navigationController?.navigationBar.isHidden = false
                  setBackButton(tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , isImage: true)
                  title = "Quotation Requests"

              }
          override func backBtnTapAction() {
                 self.navigationController?.popViewController(animated: true)
             }
    
//MARK:-New Quotation Request Button Action
    @IBAction func btnNewQuoteReq(_ sender: UIButton) {
       //if Defaults.MemberModel.getMemberModel()?.status == 1 {
        if Defaults.MemberModel.getMemberModel() != nil {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "RequestDetailsVC") as! RequestDetailsVC
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            // create the alert
            let alert = UIAlertController(title: "USER NOT FOUND", message: "Please fill up all the information in My Profile before submitting a quotation request.", preferredStyle: UIAlertController.Style.alert)

            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil ))
            alert.addAction(UIAlertAction(title: "My Profile", style: UIAlertAction.Style.destructive, handler: { action in

                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
                self.navigationController?.pushViewController(viewController, animated: true)

            }))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
}
//MARK:- To Set The Footer View Configuration
extension QuotationReqVC {
    func footerConfig() {

        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: footerView.frame.size.height)
        tableView.tableFooterView = footerView
        tableView.tableFooterView?.frame = footerView.frame
    }
}
//MARK:- TableView DataSource Method
extension QuotationReqVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getQuotationReqData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuotationsTableCell", for: indexPath) as! QuotationsTableCell
        cell.cellDelegate = self
        cell.btnNoOfQuote.tag = indexPath.row
        cell.lblServiceName.text = getQuotationReqData[indexPath.row].quotationTypeCategory.categoryName
        cell.lblQuantity.text = "Quantity : \(getQuotationReqData[indexPath.row].quantity) "
        cell.lblServiceDescription.text = getQuotationReqData[indexPath.row].usersQuotationModelDescription
        cell.btnNoOfQuote.setTitle("\(getQuotationReqData[indexPath.row].noOfQuotes) Quotes",for: .normal)
        if getQuotationReqData[indexPath.row].requestStatus == 1 {
            cell.lblStatusString.text = ""
        } else if getQuotationReqData[indexPath.row].requestStatus == 2 {
            cell.lblStatusString.text = "You accepted 1 quote"
        } else {
            cell.lblStatusString.text = "Merchant Confirmed"
        }
         return cell
    }
    
}

//MARK:- TableView Delegates Method
extension QuotationReqVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "QuotationListVC") as! QuotationListVC
      
        viewController.quotationId = getQuotationReqData[indexPath.row].id
        viewController.service = getQuotationReqData[indexPath.row].quotationTypeCategory.categoryName
        navigationController?.pushViewController(viewController, animated: true)
    }
   
}

//MARK:- Table View Cell Class
class QuotationsTableCell: UITableViewCell {
    
    var cellDelegate: YourCellDelegate?
    
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblServiceDescription: UILabel!
    @IBOutlet weak var lblStatusString: UILabel!
    @IBOutlet weak var btnNoOfQuote: UIButton!
    
    @IBAction func btnQuotePressed(_ sender: UIButton) {
        
         cellDelegate?.didPressButton(sender.tag)
//
    }
}

//MARK:- Google Ads Implementation
extension QuotationReqVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        tableView.tableFooterView?.frame = footerView.frame
        tableView.tableFooterView = footerView
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
}

//MARK:- Assigning Protocol Delegate to View Controller
extension QuotationReqVC: YourCellDelegate {
    func didPressButton(_ tag: Int) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "QuotationListVC") as! QuotationListVC
        //viewController.sts = getQuotationReqData[tag].status
        viewController.quotationId = getQuotationReqData[tag].id
        viewController.service = getQuotationReqData[tag].quotationTypeCategory.categoryName
        navigationController?.pushViewController(viewController, animated: true)
    }
}


//MARK:-API Calling
extension QuotationReqVC {
    //MARK:- API Calling for Users Quotations
         func quoteDetails()  {
            let param: [String: Any] = ["user_id": userData?.id ?? 0]
                print(param)
                APIManager().postDatatoServer(UsersQuotationsAPI, parameter: param as NSDictionary, success: { (response) in
                    print(response)
                    let responseDict = response.dictionaryObject
                    guard responseDict?["status"] as? Int == 1 else {
                        Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                        return
                    }
                    guard let getData = responseDict?["quotation_by_user"] as? [[String: Any]] else {
                       Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .success)
                       return
                   }
                   do{
                       let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                       let decoder = JSONDecoder()
                       self.getQuotationReqData = try decoder.decode([UsersQuotationModelElement].self, from: jsonData)
                    self.tableView.reloadData()
                    
                    print(self.getQuotationReqData )
                     
                   }  catch let err {
                       print("Err", err)
                   }
                  
                }) { (error) in
                   // TostErrorMessage(view:self.view,message:error.localizedDescription)
                }
            }
    
    //MARK:- API Calling for Users Status
    func checkUserStatus()  {
       let param: [String: Any] = ["user_id": userData?.id ?? 0]
           print(param)
           APIManager().postDatatoServer(getUserStatusAPI, parameter: param as NSDictionary, success: { (response) in
               print(response)
               let responseDict = response.dictionaryObject
               guard responseDict?["status"] as? Int == 1 else {
                  // Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                   return
               }
                self.getActiveStatus = responseDict?["user_status"] as? Int
                if self.getActiveStatus == 0 {
                    self.inActive()
                } else {
                    self.Active()
                }
           }) { (error) in
              // TostErrorMessage(view:self.view,message:error.localizedDescription)
           }
       }
    
    //MARK:- API Calling for Support Number
    func supportNo()  {
      
        APIManager().postDatatoServer(supportNumberAPI, parameter: [:],  success: { (response) in
               print(response)
               let responseDict = response.dictionaryObject
               guard responseDict?["status"] as? Int == 1 else {
                   Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                   return
               }
               guard let getData = responseDict?["setting"] as? [[String: Any]] else {
                  Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .success)
                  return
              }
              do{
                  let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                  let decoder = JSONDecoder()
                  self.getSupportNum = try decoder.decode([SupportNumberModelElement].self, from: jsonData)
                self.lblSupportNumber.text = "Please Whatsapp us at \(self.getSupportNum[0].whatsappNumber) for support"
                print(self.getSupportNum )
                
              }  catch let err {
                  print("Err", err)
              }
             
           }) { (error) in
              // TostErrorMessage(view:self.view,message:error.localizedDescription)
           }
       }
}

// MARK:- Function For  User INActive Actions
extension QuotationReqVC {
    func inActive() {
        self.mainView.isUserInteractionEnabled = false
        self.mainView.alpha = 0.5
        // create the alert
            let alert = UIAlertController(title: "", message: "Your account has been deactivated", preferredStyle: UIAlertController.Style.alert)

            // add the actions (buttons)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in
                self.navigationController?.popViewController(animated: true)

            }))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    
    func Active() {
        self.mainView.isUserInteractionEnabled = true
        self.mainView.alpha = 1
    }
}



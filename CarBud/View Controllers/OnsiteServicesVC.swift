//
//  OnsiteServicesVC.swift
//  CarBud
//
//  Created by kishlay kishore on 27/02/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CallKit

protocol CallingDelegate : class {
    func btnCallingPressed(_ tag: Int)
}

class OnsiteServicesVC: UIViewController {

    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var selectedIndex: Int = 0
    var getServicesData = [ServiceCategoryModelElement]()
    var getServiceProvidersData = [OnsiteServicesModelElement]()
    
    @IBOutlet var footerView : GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getServicesView: UIView!
    @IBOutlet weak var lblServicesTitle: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
         self.setNavigationbarThemeGradientColor()
        
         footerView.adUnitID = "ca-app-pub-8501671653071605/1974659335"
         footerView.rootViewController = self
         let adRequest = GADRequest()
         adRequest.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
         footerView.load(GADRequest())
         footerConfig()
         PickerViewConnection()
         serviceCategory()
        
    }
    override func viewWillAppear(_ animated: Bool) {
              
               
               self.navigationController?.navigationBar.isHidden = false
               setBackButton(tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , isImage: true)
               title = "Onsite Services"

           }
       override func backBtnTapAction() {
              self.navigationController?.popViewController(animated: true)
          }
//MARK:-Picker View Setup
        func PickerViewConnection() {
          picker = UIPickerView.init()
          picker.delegate = self
          picker.dataSource = self
          picker.backgroundColor = UIColor.white
          picker.setValue(UIColor.black, forKey: "textColor")
          picker.autoresizingMask = .flexibleWidth
          picker.contentMode = .center
          picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
           
          toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
          toolBar.barStyle = .blackTranslucent
         let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onDoneButtonTapped))
         let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onCancelButtonTapped))
         let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         toolBar.setItems([cancel, flexibleSpace, done], animated: false)
       }
   //MARK:-View action To get Services
    @IBAction func ServicesViewTapped(_ sender: UIView) {
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
    }
    
   
   
       //MARK:- The Function For the Picker Done button
      @objc func onDoneButtonTapped() {
           let dataIndex: Int = picker.selectedRow(inComponent: 0)
        lblServicesTitle.text = getServicesData[dataIndex].categoryName
           toolBar.removeFromSuperview()
           picker.removeFromSuperview()
        getServiceProviders(id:getServicesData[dataIndex].id)
           lblServicesTitle.resignFirstResponder()
       }
    //MARK:- The Function For the Picker Cancel button
        @objc func onCancelButtonTapped() {
             toolBar.removeFromSuperview()
             picker.removeFromSuperview()
         }
}


//MARK:- UiPicker View DataSource Assigning
extension OnsiteServicesVC : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return getServicesData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getServicesData[row].categoryName
    }
    
}
//MARK:- UiPicker View Delegate Assigning
extension OnsiteServicesVC : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//         let itemselected = extraServices[row]
//         lblGetServices.text = itemselected
    }
}
//MARK:- To Set The Footer View Configuration
extension OnsiteServicesVC {
    func footerConfig() {
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: footerView.frame.size.height)
        tableView.tableFooterView = footerView
        tableView.tableFooterView?.frame = footerView.frame
    }
}
//MARK:- TableView DataSource Method
extension OnsiteServicesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getServiceProvidersData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnsiteServiceTableCell", for: indexPath) as! OnsiteServiceTableCell
         cell.cellDelegate = self
         cell.btnCall.tag = indexPath.row
         cell.lblCompanyName.text = getServiceProvidersData[indexPath.row].company
         cell.lblPhoneno.text = getServiceProvidersData[indexPath.row].contactNumber
         cell.lblOperatingHrs.text = getServiceProvidersData[indexPath.row].operatingHours.htmlToString
         return cell
    }
    
}

//MARK:- TableView Delegates Method
extension OnsiteServicesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }
}

//MARK:- Table View Cell Class
class OnsiteServiceTableCell : UITableViewCell {
    
    var cellDelegate: CallingDelegate?
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblPhoneno: UILabel!
    @IBOutlet weak var lblOperatingHrs: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    
    @IBAction func btnCallingPresed(_ sender: UIButton) {
        
        cellDelegate?.btnCallingPressed(sender.tag)
    }
}

//MARK:- Assigning the protocol delegate
extension OnsiteServicesVC : CallingDelegate {
    
    
    func btnCallingPressed(_ tag: Int) {
        var phoneNumber = "\(getServiceProvidersData[tag].contactNumber)"
        var finalNumber = ""
        let trimmedNumber : String = phoneNumber.components(separatedBy: [" ", "-", "(", ")"]).joined()
        finalNumber = trimmedNumber
        print(finalNumber)
        
        let newStringPhone = finalNumber.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
           print(newStringPhone)
        if let phoneCallURL:NSURL = NSURL(string:"telprompt:\(newStringPhone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
          }
        }
       
    }
    
    
}
//MARK:- APi Calling For Getting Services On Dropdown
extension OnsiteServicesVC {
    func serviceCategory()  {
        APIManager().requestGETURL(getServiceCategoryAPI, success: { (response) in
            print(response)
            let responseDict = response.dictionaryObject
            guard responseDict?["status"] as? Bool ?? false, let getData = responseDict?["data"] as? [[String: Any]] else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                self.getServicesData = try decoder.decode([ServiceCategoryModelElement].self, from: jsonData)
                if self.getServicesData.count > 0 {
                   
                    self.lblServicesTitle.text = "Select Service"
                }
                print(self.getServicesData)
                self.tableView.reloadData()
                
            } catch {
                
            }
        }) { (error) in
            print(error)
        }
        
    }
    
   //MARK:- API Calling for Getting Service Providers
       func getServiceProviders(id:Int)  {
           let param: [String: Any] = ["cat_id": id ]
              
              APIManager().postDatatoServer(onsiteServiceProvidersAPI, parameter: param as NSDictionary, success: { (response) in
                  print(response)
                  let responseDict = response.dictionaryObject
                  guard responseDict?["status"] as? Int == 1 else {
                      Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                      return
                  }
                  guard let getData = responseDict?["data"] as? [[String: Any]] else {
                     Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                     return
                 }
                 do{
                     let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                     let decoder = JSONDecoder()
                     self.getServiceProvidersData = try decoder.decode([OnsiteServicesModelElement].self, from: jsonData)
                     print(self.getServiceProvidersData)
                     self.tableView.reloadData()
                 }  catch let err {
                     print("Err", err)
                 }
              }) { (error) in
                 // TostErrorMessage(view:self.view,message:error.localizedDescription)
              }
          }
}
//MARK:- Google Ads Implementation
extension OnsiteServicesVC : GADBannerViewDelegate {
    
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

//
//  RetriveAccountVC.swift
//  CarBud
//
//  Created by kishlay kishore on 02/03/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import UIKit
import GoogleMobileAds

class RetriveAccountVC: UIViewController {

    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var LabelView: UIView!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var btnForGuest: UIButton!
    @IBOutlet weak var MyBannerView: GADBannerView!
    
    var getAccountRetriveData:RetriveaccountModel?
   
    
    //MARK: For Lines Under Button
    let yourAttributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.systemFont(ofSize: 14),
    .foregroundColor: #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1),
    .underlineStyle: NSUnderlineStyle.single.rawValue]
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
            self.setNavigationbarThemeGradientColor()
        
        MyBannerView.adUnitID = "ca-app-pub-8501671653071605/1974659335"
        MyBannerView.rootViewController = self
        let adRequest = GADRequest()
        adRequest.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        MyBannerView.load(GADRequest())
        txtEmailAddress.delegate = self
        LabelView.isHidden = true
        
        let attributeString = NSMutableAttributedString(string: "Continue As Guest",
                                                        attributes: yourAttributes)
        btnForGuest.setAttributedTitle(attributeString, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
           
            self.navigationController?.navigationBar.isHidden = false
            setBackButton(tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , isImage: true)
            title = "Retrieve Your Account"
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    override func backBtnTapAction() {
           self.navigationController?.popViewController(animated: true)
       }
//MARK:- Next Button Action
    @IBAction func btnNext(_ sender: UIButton) {
       if !Validation.isValidEmail(for: txtEmailAddress.text ?? "") {
           Common.showAlertMessage(message: Messages.invalidEmail, alertType: .error)
           return
       }
        retriveAccountData()
       
    }
//MARK:- Button For Guest Pressed
    @IBAction func btnContinueForGuest(_ sender: UIButton) {
//        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if Defaults.MemberModel.getMemberModel() != nil {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
//MARK:- Text Field Delegate Assigning(For Floating Label EditText)
extension RetriveAccountVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lengthToAdd = string.utf16.count
        let lengthToReplace = range.length
        let newLength = (txtEmailAddress.text!.utf16.count ) + lengthToAdd - lengthToReplace
        if (newLength > 0) {
            LabelView.isHidden = false
        } else {
            LabelView.isHidden = true
        }
        return true
    }

  }
    
//MARK:- Google Ads Implementation
extension RetriveAccountVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        bannerView.frame = MyBannerView.frame
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
}

//MARK:-API Calling
extension RetriveAccountVC {
    //MARK:- API Calling for Retriving Account
         func retriveAccountData()  {
            let param: [String: Any] = ["email": txtEmailAddress.text!.trim()]
                
                APIManager().postDatatoServer(retriveAccountAPI, parameter: param as NSDictionary, success: { (response) in
                    print(response)
                    let responseDict = response.dictionaryObject
                    guard responseDict?["status"] as? Int == 1 else {
                        Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                        return
                    }
                    guard let getData = responseDict?["data"] as? [String: Any] else {
                       Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .success)
                       return
                   }
                   do{
                       let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                       let decoder = JSONDecoder()
                       self.getAccountRetriveData = try decoder.decode(RetriveaccountModel.self, from: jsonData)
                       print(self.getAccountRetriveData ?? "")
                       let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpVC") as! VerifyOtpVC
                       viewController.userid = self.getAccountRetriveData?.userID
                       viewController.code = self.getAccountRetriveData?.code ?? ""
                       
                       self.navigationController?.pushViewController(viewController, animated: true)
                     
                   }  catch let err {
                       print("Err", err)
                   }
                  
                }) { (error) in
                   // TostErrorMessage(view:self.view,message:error.localizedDescription)
                }
            }
}





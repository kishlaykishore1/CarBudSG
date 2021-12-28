//
//  MyProfileVC.swift
//  CarBud
//
//  Created by kishlay kishore on 26/02/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {
    
    var radioValue = 1
    var userData = Defaults.MemberModel.getMemberModel()
    var newIdData:NewProfileDataModel?
    var getActiveStatus:Int?
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgName: UIImageView!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var imgMobileNo: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var txtCarBrand: UITextField!
    @IBOutlet weak var txtCarModel: UITextField!
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var txtLicensePlate: UITextField!
    @IBOutlet weak var imgLisence: UIImageView!
    @IBOutlet weak var btnRetrieveMyAccount: UIButton!
    @IBOutlet weak var btnRadioOn: UIButton!
    @IBOutlet weak var btnRadioOff: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK: For Lines Under Button
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 20),
        .foregroundColor: #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1),
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationbarThemeGradientColor()
        btnSave.backgroundColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1)
       if UserDefaults.standard.integer(forKey: "VerifiedUser") == 1 {
            btnRetrieveMyAccount.isHidden = true
            txtEmail.isEnabled = false
            txtEmail.isUserInteractionEnabled = false
        } else {
            btnRetrieveMyAccount.isHidden = false
            txtEmail.isEnabled = true
            txtEmail.isUserInteractionEnabled = true
        }
        txtEmail.text = userData?.email
        let des = "\(userData?.firstName ?? "")"
        txtName.text = des
        
            txtMobileNo.text = "\(userData?.phoneNo ?? "" )"
        
        
        txtCarBrand.text = userData?.carBrand
        txtCarModel.text = userData?.carModel
        txtLicensePlate.text = userData?.licensePlate
        if userData != nil && userData?.isNotification == 1 {
            btnRadioOn.setImage(#imageLiteral(resourceName: "RadioChecked"), for: .normal)
            btnRadioOff.setImage(#imageLiteral(resourceName: "RadioUnchecked"), for: .normal)
        } else if userData == nil  {
            btnRadioOn.setImage(#imageLiteral(resourceName: "RadioChecked"), for: .normal)
            btnRadioOff.setImage(#imageLiteral(resourceName: "RadioUnchecked"), for: .normal)
        } else {
            btnRadioOn.setImage(#imageLiteral(resourceName: "RadioUnchecked"), for: .normal)
            btnRadioOff.setImage(#imageLiteral(resourceName: "RadioChecked"), for: .normal)
        }
        
        let attributeString = NSMutableAttributedString(string: "Retrieve My Account",
                                                        attributes: yourAttributes)
        btnRetrieveMyAccount.setAttributedTitle(attributeString, for: .normal)
        
        txtName.addTarget(self, action:#selector(textFieldDidChange), for: .editingChanged)
        txtEmail.addTarget(self, action:#selector(textFieldDidChange), for: .editingChanged)
        txtMobileNo.addTarget(self, action:#selector(textFieldDidChange), for: .editingChanged)
        txtLicensePlate.addTarget(self, action:#selector(textFieldDidChange), for: .editingChanged)
        txtCarBrand.addTarget(self, action:#selector(textFieldDidChange), for: .editingChanged)
        txtCarModel.addTarget(self, action:#selector(textFieldDidChange), for: .editingChanged)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        checkUserStatus()
        self.navigationController?.navigationBar.isHidden = false
        setBackButton(tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , isImage: true)
        title = "My Profile"
        
    }
    override func backBtnTapAction() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Retrieve My Account Button Pressed
    @IBAction func btnRetriveAccountPressed(_ sender: UIButton) {
        let strybd = UIStoryboard(name: "Main", bundle: nil)
        let viewController = strybd.instantiateViewController(withIdentifier: "RetriveAccountVC") as! RetriveAccountVC
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    //MARK:- Radio Button Action
    @IBAction func btnNotificationInput(_ sender: UIButton) {
        if sender.tag == 1 {
            btnRadioOn.setImage(#imageLiteral(resourceName: "RadioChecked"), for: .normal)
            btnRadioOff.setImage(#imageLiteral(resourceName: "RadioUnchecked"), for: .normal)
            radioValue = 1
        } else {
            btnRadioOn.setImage(#imageLiteral(resourceName: "RadioUnchecked"), for: .normal)
            btnRadioOff.setImage(#imageLiteral(resourceName: "RadioChecked"), for: .normal)
            radioValue = 0
        }
        
    }
    //MARK:- Save Button Pressed Action
    @IBAction func btnSavePressed(_ sender: UIButton) {
        myProfileSave()
    }
}

extension MyProfileVC:UITextFieldDelegate {
    @objc func textFieldDidChange(textField: UITextField) {
        if Validation.isBlank(for: txtName.text ?? "") {
            imgName.image = #imageLiteral(resourceName: "ErrorIcon")
             btnSave.isEnabled = false
             btnSave.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            imgName.image = #imageLiteral(resourceName: "CorrectIcon")
            btnSave.isEnabled = true
            btnSave.backgroundColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1)
        }
        if !Validation.isValidEmail(for: txtEmail.text ?? "") {
            imgEmail.image = #imageLiteral(resourceName: "ErrorIcon")
            btnSave.isEnabled = false
            btnSave.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            imgEmail.image = #imageLiteral(resourceName: "CorrectIcon")
            btnSave.isEnabled = true
            btnSave.backgroundColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1)
        }
        if !Validation.isValidMobileNumber(value: txtMobileNo.text ?? "") {
            imgMobileNo.image = #imageLiteral(resourceName: "ErrorIcon")
            btnSave.isEnabled = false
            btnSave.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            imgMobileNo.image = #imageLiteral(resourceName: "CorrectIcon")
            btnSave.isEnabled = true
            btnSave.backgroundColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1)
           
        }
        if Validation.isBlank(for: txtCarModel.text ?? "") || Validation.isBlank(for: txtCarBrand.text ?? "")  {
            imgCar.image = #imageLiteral(resourceName: "ErrorIcon")
            btnSave.isEnabled = false
            btnSave.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            imgCar.image = #imageLiteral(resourceName: "CorrectIcon")
            btnSave.isEnabled = true
            btnSave.backgroundColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1)
        }
        if Validation.isBlank(for: txtLicensePlate.text ?? "") {
            imgLisence.image = #imageLiteral(resourceName: "ErrorIcon")
            btnSave.isEnabled = false
            btnSave.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            imgLisence.image = #imageLiteral(resourceName: "CorrectIcon")
            btnSave.isEnabled = true
            btnSave.backgroundColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1)
        }
    }
}

//MARK:- API Calling
extension MyProfileVC {
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
    
    //MARK:- API Calling for Save Button Pressed
    func myProfileSave()  {
        if UserDefaults.standard.integer(forKey: "VerifiedUser") != 0 {
            let param: [String: Any] = ["first_name": txtName.text ?? "","phone_no": txtMobileNo.text ?? "" ,"email":txtEmail.text ?? "","car_brand": txtCarBrand.text ?? "" ,"car_model":txtCarModel.text ?? "","license_plate": txtLicensePlate.text ?? "" ,"is_notification": radioValue ,"user_id": Defaults.MemberModel.getMemberModel()?.id ?? 0,"device_token": ""]
            
            APIManager().postDatatoServer(myProfileAPI, parameter: param as NSDictionary, success: { (response) in
                
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
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    self.newIdData = try decoder.decode(NewProfileDataModel.self, from: jsonData)
                    Defaults.MemberModel.storeMemberModel(value: getData)
                    Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .success)
                    self.navigationController?.popViewController(animated: true)
                    print(self.newIdData ?? "")
                    
                }  catch let err {
                    print("Err", err)
                }
            }) { (error) in
                TostErrorMessage(view:self.view,message:error.localizedDescription)
            }
        } else {
            let param: [String: Any] = ["first_name": txtName.text ?? "","phone_no": txtMobileNo.text ?? "" ,"email":txtEmail.text ?? "","car_brand": txtCarBrand.text ?? "" ,"car_model":txtCarModel.text ?? "","license_plate": txtLicensePlate.text ?? "" ,"is_notification": radioValue,"device_token": "" ]
            
            APIManager().postDatatoServer(myProfileAPI, parameter: param as NSDictionary, success: { (response) in
                
                print(response)
                let responseDict = response.dictionaryObject
                guard responseDict?["status"] as? Int == 1 else {
                    Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                    // create the alert
                    let alert = UIAlertController(title: "Email Already Exist", message: "This email has been used before. Please click on the “Retrieve my account”link to retrieve your information.", preferredStyle: UIAlertController.Style.alert)
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil ))
                    alert.addAction(UIAlertAction(title: "Retrive Account", style: UIAlertAction.Style.destructive, handler: { action in
                        
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RetriveAccountVC") as! RetriveAccountVC
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                guard let getData = responseDict?["data"] as? [String: Any] else {
                    Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .success)
                    return
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    self.newIdData = try decoder.decode(NewProfileDataModel.self, from: jsonData)
                    UserDefaults.standard.set(1, forKey: "VerifiedUser")
                    Defaults.MemberModel.storeMemberModel(value: getData)
                    Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .success)
                    self.navigationController?.popViewController(animated: true)
                    print(self.newIdData ?? "")
                    
                }  catch let err {
                    print("Err", err)
                }
            }) { (error) in
                TostErrorMessage(view:self.view,message:error.localizedDescription)
            }
        }
        
        
        
    }
    
    
}
// MARK:- Function For  User INActive Actions
extension MyProfileVC {
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

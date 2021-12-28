//
//  RequestDetailsVC.swift
//  CarBud
//
//  Created by kishlay kishore on 28/02/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class RequestDetailsVC: BaseImagePicker {
    var pickerView : UIPickerView?
    var getQuotationData = [QuotationCategoryModelElement]()
    var id : Int = 0
    let userData = Defaults.MemberModel.getMemberModel()
    var getSupportNum = [SupportNumberModelElement]()
    var getActiveStatus:Int?
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var afterSubmitView: UIView!
    @IBOutlet weak var lblSupportNo: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var txtServices: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnRequst: UIButton!
    @IBOutlet weak var lblFinal: UILabel!
    @IBOutlet weak var lblImageView: UILabel!
    @IBOutlet weak var btnDeleteImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         supportNo()
        self.setNavigationbarThemeGradientColor()
        lblFinal.isHidden = true
        afterSubmitView.isHidden = true
        btnRequst.isHidden = false
        lblImageView.isHidden = false
        imgPhoto.isUserInteractionEnabled = true
        pickerView?.isUserInteractionEnabled = true
        txtDescription.isUserInteractionEnabled = true
        txtQuantity.isUserInteractionEnabled = true
        PickerViewConnection()
        quotationCategory()
        txtServices.setLeftPaddingPoints(8)
        txtQuantity.setLeftPaddingPoints(8)
        txtServices.addLeftImageTo(txtField: txtServices, andImage: #imageLiteral(resourceName: "angle-arrow-down"), isLeft: false)
        //MARK: for setting The Tap Guester on image view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgPhoto.isUserInteractionEnabled = true
        imgPhoto.addGestureRecognizer(tapGestureRecognizer)
      
    }
    override func viewWillAppear(_ animated: Bool) {
            supportNo()
        checkUserStatus()
        self.navigationController?.navigationBar.isHidden = false
        setBackButton(tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , isImage: true)
        title = "Request Details"
    }
    //MARK:- Functionallity for Image View Tap
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        openOptions()
    }
    override func selectedImage(chooseImage: UIImage) {
        imgPhoto.image = chooseImage
        lblImageView.isHidden = true
    }
    
    override func backBtnTapAction() {
        self.navigationController?.popViewController(animated: true)
    }
 //MARK:-Action for cross button On Image View
    @IBAction func btnImageCancelPressed(_ sender: UIButton) {
        imgPhoto.image = nil
    }
    
    //MARK:- UIPickerView Delegates assigning
    func PickerViewConnection() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtServices.delegate = self
        txtServices.inputView = pickerView
        
        self.pickerView = pickerView
    }
    
    
    //MARK:- Request For Quotation Pressed Action
    @IBAction func btnRequestForQuote(_ sender: UIButton) {
         if Validation.isBlank(for: txtServices.text ?? "") {
                    Common.showAlertMessage(message: Messages.emptyServices, alertType: .error)
                    return
                }
          
              else if Validation.isBlank(for: txtDescription.text ?? "") {
                    Common.showAlertMessage(message: Messages.emptyServices, alertType: .error)
                    
                    return
                }
               else if Validation.isBlank(for: txtQuantity.text ?? "") {
                    Common.showAlertMessage(message: Messages.emptyServices, alertType: .error)
                    return
                }
        requestService()
    }
}

//MARK:-UITextField delegates Methods
extension RequestDetailsVC: UITextFieldDelegate {
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView?.reloadAllComponents()
    }
}
//MARK:- Uipicker DataSource Method
extension RequestDetailsVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return getQuotationData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getQuotationData[row].categoryName
        
    }
}
//MARK:- Uipicker Delegate Method
extension RequestDetailsVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let itemselected = getQuotationData[row].categoryName
        id = getQuotationData[row].id
        txtServices.text = itemselected
        self.lblComment.text = getQuotationData[row].commentForDescription.htmlToString
        self.lblImageView.text = self.getQuotationData[row].commentForPhoto.htmlToString
        
    }
}
//MARK:- APi Calling For Services Text Field
extension RequestDetailsVC {
    func quotationCategory()  {
        APIManager().requestGETURL(getQuoteCategoryAPI, success: { (response) in
            print(response)
            let responseDict = response.dictionaryObject
            guard responseDict?["status"] as? Bool ?? false, let getData = responseDict?["data"] as? [[String: Any]] else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                self.getQuotationData = try decoder.decode([QuotationCategoryModelElement].self, from: jsonData)
                print(self.getQuotationData)
                
            } catch {
                
            }
        }) { (error) in
            print(error)
        }
        
    }
    
    //MARK:- API CALLING For Submitting The Quotation
    func requestService()  {
        let param: [String: Any] = ["user_id": userData?.id ?? 0 ,"category_id": id ,"description": txtDescription.text?.trim() ?? "","quantity":txtQuantity.text?.trim() ?? ""]
        print(param)
        APIManager().requestUpload("quotation_request", with: param, files: ["photo": imgPhoto.image ?? ""]) { (jsonObject, error) in
            guard error == nil, (jsonObject?["status"] as! Bool ) else {
                Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .error)
                return
            }
            Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .success)
            self.btnRequst.isHidden = true
            self.afterSubmitView.isHidden = false
            self.lblFinal.isHidden = false
            self.imgPhoto.isUserInteractionEnabled = false
            self.pickerView?.isUserInteractionEnabled = false
            self.txtDescription.isUserInteractionEnabled = false
            self.txtQuantity.isUserInteractionEnabled = false
            
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
                self.lblSupportNo.text = "Please Whatsapp us at \(self.getSupportNum[0].whatsappNumber) for support"
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
extension RequestDetailsVC {
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



//
//  QuotationDetailsVC.swift
//  CarBud
//
//  Created by kishlay kishore on 27/02/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import UIKit

class QuotationDetailsVC: UIViewController {
    
    @IBOutlet weak var lblValidTime: UILabel!
    @IBOutlet weak var lblServiceDescription: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var txtMerchantRemarks: UITextView!
    @IBOutlet weak var imgImageSelect: UIImageView!
    @IBOutlet weak var txtOutlet: UITextField!
    @IBOutlet weak var txtAppointment: UITextField!
    @IBOutlet weak var txtRejectionReason: UITextView!
    @IBOutlet weak var lblSupportNo: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblOutletTime: UILabel!
    @IBOutlet weak var lblRejectedReason: UILabel!
    @IBOutlet weak var lblRejectionStar: UILabel!
    
    var id : Int?
    var pickerView : UIPickerView?
    let datePicker = UIDatePicker()
    var getOutletData = [MerchantOutletModelElement]()
    var getSupportNum = [SupportNumberModelElement]()
    var getQuoteDetails: QuotationDetailsModel?
    var merchantID:Int?
    var quoteID:Int?
    var sts:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportNo()
        quoteDetails()
        
        btnAccept.isEnabled = true
        btnAccept.backgroundColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1)
        txtOutlet.isEnabled = true
        txtOutlet.isUserInteractionEnabled = true
        txtMerchantRemarks.isUserInteractionEnabled = false
        PickerViewConnection()
        showDatePicker()
        self.setNavigationbarThemeGradientColor()
        txtOutlet.addLeftImageTo(txtField: txtOutlet, andImage: #imageLiteral(resourceName: "angle-arrow-down"), isLeft: false)
        txtAppointment.addLeftImageTo(txtField: txtAppointment, andImage: #imageLiteral(resourceName: "angle-arrow-down"), isLeft: false)
        
    }
    
    
    //MARK:- UIPickerView Delegates assigning
    func PickerViewConnection() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtOutlet.delegate = self
        txtOutlet.inputView = pickerView
        
        self.pickerView = pickerView
    }
    //MARK:-Date Picker Setup
    func showDatePicker(){
        //Formate Date
        if (getCurrentTimeUsingCalendar() ?? 0) >= 16 {
            datePicker.minimumDate = addDate(daysToAdd: 2)
        } else {
            datePicker.minimumDate = addDate(daysToAdd: 1)
        }
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtAppointment.inputAccessoryView = toolbar
        txtAppointment.inputView = datePicker
        
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yy"
        txtAppointment.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    //MARK:- Data Setting For the View
    func dataSet() {
        lblCompany.text = getQuoteDetails?.merchant.companyName
        lblServiceDescription.text = getQuoteDetails?.quotedItem
        lblValidTime.text = "Valid till \(getQuoteDetails?.priceExpiryDate ?? "")"
        lblQuantity.text = "Qty:\(getQuoteDetails?.quantityQuoted ?? 0)(\(getQuoteDetails?.stockOnHand ?? 0) Left)"
        lblPrice.text = getQuoteDetails?.totalCost
        txtMerchantRemarks.text = getQuoteDetails?.merchantRemarks ?? ""
        if let apiUrl = getQuoteDetails?.photos {
            if let url = URL(string: imgUrl + apiUrl ) {
                 imgImageSelect.af_setImage(withURL: url)
            }else {
                 imgImageSelect.image = #imageLiteral(resourceName: "Group 1")
             }
        } else {
            imgImageSelect.image = #imageLiteral(resourceName: "Group 1")
        }
        
        if let date = getQuoteDetails?.appointment {
            txtAppointment.text = apiDateFormat(text: String(date.split(separator: " ")[0]))
        }
        
        // self.apiDate = getQuoteDetails?.appointment
        txtRejectionReason.text = getQuoteDetails?.rejectionReason
        
        
        
        if sts == 2 || sts == 4 {
            txtOutlet.isUserInteractionEnabled = false
            txtAppointment.isUserInteractionEnabled = false
            btnAccept.isEnabled = false
            btnAccept.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
        } else {
            txtOutlet.isUserInteractionEnabled = true
            txtAppointment.isUserInteractionEnabled = true
            btnAccept.isEnabled = true
            btnAccept.backgroundColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.05098039216, alpha: 1)
        }
        
        if sts == 3 && txtRejectionReason.text != nil {
            txtRejectionReason.isHidden = false
            lblRejectionStar.isHidden = false
            lblRejectedReason.isHidden = false
        } else {
            txtRejectionReason.isHidden = true
            lblRejectionStar.isHidden = true
            lblRejectedReason.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        setBackButton(tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , isImage: true)
        title = "Quotation Details"
        
    }
    override func backBtnTapAction() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:-Button Action for Accept Button
    @IBAction func btnAcceptPressed(_ sender: UIButton) {
        if Validation.isBlank(for: txtOutlet.text ?? "") {
               Common.showAlertMessage(message: Messages.emptyServices, alertType: .error)
               return
           }
         else if Validation.isBlank(for: txtAppointment.text ?? "") {
               Common.showAlertMessage(message: Messages.emptyServices, alertType: .error)
               
               return
           }
        
    statusupdate()
    }
}

//MARK:-UITextField delegates Methods
extension QuotationDetailsVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView?.reloadAllComponents()
    }
}
//MARK:- Uipicker DataSource Method
extension QuotationDetailsVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return getOutletData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getOutletData[row].address
        
    }
}
//MARK:- Uipicker Delegate Method
extension QuotationDetailsVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let itemselected = getOutletData[row].address
        id = getOutletData[row].id
        txtOutlet.text = itemselected
        lblOutletTime.text = getOutletData[row].operatingHours?.htmlToString
        
    }
}

//MARK:-API Calling
extension QuotationDetailsVC {
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
    
    //MARK:- API Calling for Quotations Details
    func quoteDetails()  {
        let param: [String: Any] = ["quotation_id": quoteID ?? 0]
        print(param)
        APIManager().postDatatoServer(quotationDetailsAPI, parameter: param as NSDictionary, success: { (response) in
            print(response)
            let responseDict = response.dictionaryObject
            guard responseDict?["status"] as? Int == 1 else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                return
            }
            guard let getData = responseDict?["quotation_details"] as? [String: Any] else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .success)
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                self.getQuoteDetails = try decoder.decode(QuotationDetailsModel.self, from: jsonData)
                self.dataSet()
                print(self.getQuoteDetails ?? "" )
                self.merchantOutlet()
                
            }  catch let err {
                print("Err", err)
            }
            
        }) { (error) in
            // TostErrorMessage(view:self.view,message:error.localizedDescription)
        }
    }
    
    //MARK:- API Calling for Merchant Outlets
    func merchantOutlet()  {
        let param: [String: Any] = ["merchant_id": merchantID ?? 0]
        print(param)
        APIManager().postDatatoServer(merchantOutletAPI, parameter: param as NSDictionary, success: { (response) in
            print(response)
            let responseDict = response.dictionaryObject
            guard responseDict?["status"] as? Int == 1 else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                return
            }
            guard let getData = responseDict?["outlet_list"] as? [[String: Any]] else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .success)
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                self.getOutletData = try decoder.decode([MerchantOutletModelElement].self, from: jsonData)
                var operatingHrs = ""
                if self.getOutletData.count == 1 {
                    self.txtOutlet.text = self.getOutletData[self.pickerView?.selectedRow(inComponent: 0) ?? 0].address
                    operatingHrs = self.getOutletData[self.pickerView?.selectedRow(inComponent: 0) ?? 0].operatingHours ?? ""
                    self.lblOutletTime.text = operatingHrs.htmlToString
                } else {
                    self.txtOutlet.text = ""
                    self.lblOutletTime.text = ""
                }
                
                if (self.sts) > 1 {
                    for (index,data) in self.getOutletData.enumerated(){
                        if data.id == self.getQuoteDetails?.outletID {
                            self.pickerView?.selectRow(index, inComponent: 0, animated: true)
                            operatingHrs = data.operatingHours ?? ""
                            self.txtOutlet.text = data.address
                            self.lblOutletTime.text = operatingHrs.htmlToString
                        }
                    }
                }
                
                print(self.getOutletData)
                
            }  catch let err {
                print("Err", err)
            }
            
        }) { (error) in
            // TostErrorMessage(view:self.view,message:error.localizedDescription)
        }
    }
    
    //MARK:- API Calling for Accept Button Action
    func statusupdate()  {
        let param: [String: Any] = ["quotation_id": quoteID ?? 0,"status": 2, "outlet_id":self.id ?? 0,"appointment": strDateFormat(date: txtAppointment.text!.trim())! ]
        print(param)
        APIManager().postDatatoServer(statusUpdateAPI, parameter: param as NSDictionary, success: { (response) in
            print(response)
            let responseDict = response.dictionaryObject
            guard responseDict?["status"] as? Int == 1 else {
                // Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                // create the alert
                let alert = UIAlertController(title:"ALERT", message: responseDict?["message"] as? String ?? "", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
            }
            Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .success)
            // create the alert
            let alert = UIAlertController(title:"Thank You", message: "The merchant will review your appointment date and preferred outlet and send you a confirmation soon. **Do not visit the outlet unless the merchant confirms your appointment**.", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }) { (error) in
            // TostErrorMessage(view:self.view,message:error.localizedDescription)
        }
    }
    
}
//MARK:Functions For Date Picker Logic Set
extension QuotationDetailsVC {
    
    //MARK: Get Current Time
    func getCurrentTimeUsingCalendar() -> Int? {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return hour
    }
    //MARK: Add Date To Current Date
    func addDate( daysToAdd:Int ) -> Date? {
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        
        dateComponent.day = daysToAdd
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        return futureDate
    }
    //MARK: Date Format To be Sent in Api
    func apiDateFormat(text: String) -> String?  {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: text) else { return "" }
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "d MMM yy"
        let date1 = dateFormatter1.string(from: date)
        
        return date1
    }
    func strDateFormat(date: String) -> String?  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yy"
        let strDate = dateFormatter.date(from: date)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let date1 = dateFormatter1.string(from: strDate!)
        return date1
    }
    
    
    
}

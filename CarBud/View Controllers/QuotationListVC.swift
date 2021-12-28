//
//  QuotationListVC.swift
//  CarBud
//
//  Created by kishlay kishore on 28/02/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import UIKit

class QuotationListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnServiceRequird: UIButton!
    @IBOutlet weak var lblSupportNo: UILabel!
    @IBOutlet weak var viewRequestQuote: UIView!
    @IBOutlet weak var viewAcceptedQuote: UIView!
    @IBOutlet weak var viewConfirmedQuote: UIView!
    @IBOutlet weak var lblNoOfQuote: UILabel!
    
    
    var getQuoteListData = [QuotationListElement]()
    var getSupportNum = [SupportNumberModelElement]()
    var getViewStatus:Int?
    var quotationId:Int?
    var service:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        supportNo()
        self.setNavigationbarThemeGradientColor()
        btnServiceRequird.setTitle(service, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        quoteList()
        self.navigationController?.navigationBar.isHidden = false
        setBackButton(tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , isImage: true)
        title = "Quotation List"
        
    }
    override func backBtnTapAction() {
        self.navigationController?.popViewController(animated: true)
    }
 //MARK:- Function for the View
    func statusView() {
        if getViewStatus == 1 {
            self.viewRequestQuote.backgroundColor = #colorLiteral(red: 0.5725490196, green: 0.8156862745, blue: 0.3137254902, alpha: 1)
            self.viewAcceptedQuote.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
            self.viewConfirmedQuote.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        } else if getViewStatus == 2 {
            self.viewRequestQuote.backgroundColor = #colorLiteral(red: 0.5725490196, green: 0.8156862745, blue: 0.3137254902, alpha: 1)
            self.viewAcceptedQuote.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.8745098039, blue: 0.3960784314, alpha: 1)
            self.viewConfirmedQuote.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        } else if getViewStatus == 4 {
            self.viewRequestQuote.backgroundColor = #colorLiteral(red: 0.5725490196, green: 0.8156862745, blue: 0.3137254902, alpha: 1)
            self.viewAcceptedQuote.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.8745098039, blue: 0.3960784314, alpha: 1)
            self.viewConfirmedQuote.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.8745098039, blue: 0.3960784314, alpha: 1)
        }
    }
    
}
//MARK:- TableView DataSource Method
extension QuotationListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getQuoteListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuotationListTableCell", for: indexPath) as! QuotationListTableCell
        cell.lblCompanyName.text = getQuoteListData[indexPath.row].merchant.companyName
        cell.lblServiceDes.text = getQuoteListData[indexPath.row].quotedItem
        cell.lblPrice.text = getQuoteListData[indexPath.row].totalCost
        cell.lblValidity.text = "Valid till \(getQuoteListData[indexPath.row].priceExpiryDate ?? "" )"
        cell.lblQuantity.text = "Qty:\(getQuoteListData[indexPath.row].quantityQuoted ?? 0)(\(getQuoteListData[indexPath.row].stockOnHand ?? 0) Left)"
        if getQuoteListData[indexPath.row].status == 1 {
            cell.lblMQuoteStatus.text = ""
        } else if getQuoteListData[indexPath.row].status == 2 {
            cell.lblMQuoteStatus.text = "Accepted"
            cell.viewCellMain.backgroundColor = #colorLiteral(red: 1, green: 0.9098039216, blue: 0.8705882353, alpha: 1)
            cell.viewCellMain.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1882352941, blue: 0.2274509804, alpha: 1)
            cell.viewCellMain.borderWidth = 1.0
        } else if getQuoteListData[indexPath.row].status == 3 {
            cell.lblMQuoteStatus.text = "Rejected"
        } else {
            cell.lblMQuoteStatus.text = "Confirmed"
        }
        return cell
    }
    
}

//MARK:- TableView Delegates Method
extension QuotationListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "QuotationDetailsVC") as! QuotationDetailsVC
               viewController.merchantID = getQuoteListData[indexPath.row].merchantID
        viewController.quoteID = getQuoteListData[indexPath.row].id
               viewController.sts = getQuoteListData[indexPath.row].status
               navigationController?.pushViewController(viewController, animated: true)
    }
}
//MARK:- Table View Cell Class
class QuotationListTableCell : UITableViewCell {
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblServiceDes: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var lblMQuoteStatus: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var viewCellMain: UIView!
}

//MARK:-API Calling
extension QuotationListVC {
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
    
    //MARK:- API Calling for Quotations List
    func quoteList()  {
        let param: [String: Any] = ["quotation_id": quotationId ?? 0]
        print(param)
        APIManager().postDatatoServer(quotationListAPI, parameter: param as NSDictionary, success: { (response) in
            print(response)
            let responseDict = response.dictionaryObject
            guard responseDict?["status"] as? Int == 1 else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                return
            }
            guard let getData = responseDict?["quotation_list"] as? [[String: Any]] else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .success)
                return
            }
            self.getViewStatus = responseDict?["request_status"] as? Int
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                
                self.getQuoteListData = try decoder.decode([QuotationListElement].self, from: jsonData)
                self.lblNoOfQuote.text = "Received \(self.getQuoteListData.count) Quotations"
                self.statusView()
                self.tableView.reloadData()
                print(self.getQuoteListData)
                
            }  catch let err {
                print("Err", err)
            }
            
        }) { (error) in
            // TostErrorMessage(view:self.view,message:error.localizedDescription)
        }
    }
    
}



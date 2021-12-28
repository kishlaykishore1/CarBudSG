//
//  detailViewController.swift
//  CarBud
//
//  Created by Snow-Macmini-2 on 22/07/19.
//  Copyright © 2019 Snow-Macmini-2. All rights reserved.
//

import UIKit
import BottomPopup
class detailViewController: BottomPopupViewController {

    @IBOutlet weak var slotLbl: UILabel!
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var textBgView: UIView!
    var placeID = String()
    var sections = [Section]()
    var categoryData : Section!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTable.tableFooterView = UIView(frame: .zero)
        detailTable.estimatedRowHeight = 100
        detailTable.rowHeight = UITableView.automaticDimension
        fetchDetailData()
    }
    
    func fetchDetailData()  {
        
        let params = ["car_park_id":placeID]
        
        APIManager().postDatatoServer(searchParkDetailsAPI_endPOint, parameter: params as NSDictionary, success: { (response) in
            
            print(response)
            let responseDict = response.dictionaryObject
            let status = responseDict?["status"] as? Bool ?? false
            let messageStr = responseDict?["message"] as? String ?? ""
            let carParkDict = responseDict?["carpark"] as? NSDictionary ?? [:]
            let carParkName = carParkDict["name"] as? String ?? ""
            let slotAvailableStr = carParkDict["slot"] as? String ?? ""
            let searchArr = carParkDict["days"] as? NSArray ?? []
           
            if status == true
            {
                
                        for item in searchArr
                        {

                            let newItem = item as? NSDictionary ?? [:]

                            let hasTags = newItem["day_details"] as? NSArray ?? []

                            self.categoryData = Section.init(name: newItem["category"] as? String ?? "", items: hasTags as! [NSDictionary])

                            self.sections.append(self.categoryData)
                        }
                slotAvailableStr.isEmpty == true ? (self.slotLbl.text = "N/A") : (self.slotLbl.text = "\(slotAvailableStr) Lots Available")
                
            }
            else
            {
                TostErrorMessage(view:self.view,message:messageStr)
            }
            
            self.name_lbl.text = carParkName
            self.detailTable.reloadData()
            
        }) { (error) in
           // TostErrorMessage(view:self.view,message:error.localizedDescription)
        }
    
    }
    
    override func getPopupHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height - 20

    }
    
    func timeConversion12(time24: String) -> String {
        
        print(time24)
        
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        
        let date = df.date(from: dateAsString)
        df.dateFormat = "h:mm a"
        df.amSymbol = "am"
        df.pmSymbol = "pm"
        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
  
}

class headerTableCell: UITableViewCell {
    
    @IBOutlet weak var days_lbl: UILabel!
}
class detailTableCell: UITableViewCell {
    
    @IBOutlet weak var bottomCommtlblTopLayout: NSLayoutConstraint!
    @IBOutlet weak var bottomFreeLayout: NSLayoutConstraint!
    
    @IBOutlet weak var comments_lbl: UILabel!
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var firstNAdNextCharge_lbl: UILabel!
   
    @IBOutlet weak var freeEntry: UILabel!
    @IBOutlet weak var next_lbl: UILabel!
    @IBOutlet weak var nextPrice_lbl: UILabel!
    
    @IBOutlet weak var perdayPrice_lbl: UILabel!
    @IBOutlet weak var perDay_labl: UILabel!
}

extension detailViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! detailTableCell
        let dictInfo = sections[indexPath.section].items[indexPath.row]
       
        let fromTime = dictInfo["from_time"] as? String ?? ""
        let toTime = dictInfo["to_time"] as? String ?? ""
        let Comments = dictInfo["comments"] as? String ?? ""
        let first_charge = dictInfo["first_charge"] as? String ?? ""
         let first_duration = dictInfo["first_duration"] as? String ?? ""
        let free = dictInfo["free"] as? String ?? ""
        let per_entry = dictInfo["per_entry"] as? String ?? ""
        let subsequent_charge = dictInfo["subsequent_charge"] as? String ?? ""
        let subsequent_duration = dictInfo["subsequent_duration"] as? String ?? ""
        
        //let first_duration = String(first_durationOne)
       // let subsequent_duration = String(subsequent_durationOne)
        
        cell.comments_lbl.text = nil
        cell.timeLbl.text = nil
        cell.firstNAdNextCharge_lbl.text = nil
        cell.price_lbl.text  = nil
        cell.next_lbl.text = nil
        cell.nextPrice_lbl.text = nil
        cell.perDay_labl.text = nil
        cell.perdayPrice_lbl.text = nil
        cell.freeEntry.text = nil
        
        if fromTime == "" && toTime == "" && Comments != "" {
           
            cell.comments_lbl.text = Comments
            
            cell.bottomFreeLayout.constant = -40
            cell.bottomCommtlblTopLayout.constant = 14
            
            
        }
        else if fromTime != "" || toTime != ""
        {
            if fromTime != "" && toTime == ""
            {
                let color = UIColor(rgb: 0x00bd2e)
                let FromTimeSymbol = timeConversion12(time24: fromTime)
                let myMutableString = NSMutableAttributedString(string: "From \n \(FromTimeSymbol)", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Bold", size: 17.0)!])
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location:0,length:4))
                
                cell.timeLbl.attributedText = myMutableString
                
                
            }
            else if fromTime == "" && toTime != ""
            {
                
                let ToTimeSymbol = timeConversion12(time24: toTime)
                let color = UIColor(rgb: 0xFF570D)
                let myMutableString = NSMutableAttributedString(string: "Till \n \(ToTimeSymbol)", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Bold", size: 17.0)!])
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location:0,length:4))
                cell.timeLbl.attributedText = myMutableString
                
                
            }
            else if fromTime != "" && toTime != ""
            {
                
                let FromTimeSybol = timeConversion12(time24: fromTime)
                let ToTimeSymbol = timeConversion12(time24: toTime)
                
                
                cell.timeLbl.text = "\(FromTimeSybol) \n to \n \(ToTimeSymbol)"
                
                
            }
            cell.bottomFreeLayout.constant = 5
            cell.bottomCommtlblTopLayout.constant = 14
            
            
        }
        
        if first_duration != "" && first_charge != ""
        {
            let color = UIColor(rgb: 0x654321)
            let myMutableString = NSMutableAttributedString(string: "FIRST \n \(first_duration) Mins", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Bold", size: 17.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location:0,length:5))
            cell.firstNAdNextCharge_lbl.attributedText = myMutableString
            cell.price_lbl.text = Double(first_charge)?.dollarString
            
            cell.bottomFreeLayout.constant = 5
            cell.bottomCommtlblTopLayout.constant = 14
            
        }
        
        if subsequent_duration != "" && subsequent_charge != "" {
            
            if first_duration == "" && first_charge == ""
            {
                //let color = UIColor.init(rgb: 0xFF570D)
               let color = UIColor(rgb: 0xFF570D)
                let myMutableString = NSMutableAttributedString(string: "PER \n \(subsequent_duration) Mins", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Bold", size: 17.0)!])
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location:0,length:3))
                cell.next_lbl.attributedText = myMutableString
                cell.nextPrice_lbl.text = Double(subsequent_charge)?.dollarString
                
                cell.bottomFreeLayout.constant = 5
                cell.bottomCommtlblTopLayout.constant = 14
                
            }
            else
            {
                let color = UIColor(rgb: 0xFF570D)
                let myMutableString = NSMutableAttributedString(string: "NEXT \n \(subsequent_duration) Mins", attributes: [NSAttributedString.Key.font :UIFont(name: "OpenSans-Bold", size: 17.0)!])
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location:0,length:4))
                cell.next_lbl.attributedText = myMutableString
                cell.nextPrice_lbl.text = Double(subsequent_charge)?.dollarString
                
                cell.bottomFreeLayout.constant = -20
                cell.bottomCommtlblTopLayout.constant = 14
                
            }
            
        }
        
        if per_entry != "" {
            
            cell.perDay_labl.text = "Per Entry"
            cell.perdayPrice_lbl.text = Double(per_entry)?.dollarString
            
            cell.bottomFreeLayout.constant = 40
            cell.bottomCommtlblTopLayout.constant = 14
            
        }
        
        if free == "1" {
            
            cell.freeEntry.text = "Free Entry"
            
            cell.bottomFreeLayout.constant = 60
            
            cell.bottomCommtlblTopLayout.constant = 14
        }
        
        if (Comments != "") && (fromTime != "" || toTime != "") {
            
            if free == "1"
            {
                cell.freeEntry.text = "Free Entry \n \n \n \(Comments)"
                
                
            }
            else
            {
                cell.freeEntry.text = Comments
                
                
            }
            
            if (first_duration == "" && first_charge == "") && (per_entry == "") 
            {
                
                
                
                if (Comments != "")
                {
                    cell.bottomCommtlblTopLayout.constant = 14
                    cell.bottomFreeLayout.constant = 5
                }
                else
                {
                    cell.bottomCommtlblTopLayout.constant = -50
                    cell.bottomFreeLayout.constant = 5
                }
              
                
            }
            else
            {
                cell.bottomCommtlblTopLayout.constant = 14
                
                cell.bottomFreeLayout.constant = 5
            }
            
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! headerTableCell
        headerView.days_lbl.text = sections[section].name
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

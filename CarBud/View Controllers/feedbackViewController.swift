//
//  feedbackViewController.swift
//  CarBud
//
//  Created by Snow-Macmini-2 on 19/07/19.
//  Copyright © 2019 Snow-Macmini-2. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMobileAds
class feedbackViewController: UIViewController,MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var myBannerView: GADBannerView!
    
    
    @IBOutlet weak var emailBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //adBgView.ShadowColorView()
        myBannerView.adUnitID = "ca-app-pub-9805424516869435/7693178685"
        myBannerView.rootViewController = self
        myBannerView.load(GADRequest())
        emailBtn.btnBlackBoarderWithRadius()
        
        fetchEmail()
    }
    
   
   
    
    func fetchEmail()  {
        
        let params = ["":""]
        
        APIManager().postDatatoServer(getAdminEmailAPI_endPoint, parameter: params as NSDictionary, success: { (response) in
            
            print(response)
            let responseDict = response.dictionaryObject
            let status = responseDict?["status"] as? Bool ?? false
            let messageStr = responseDict?["message"] as? String ?? ""
            let carParkArr = responseDict?["carpark"] as? NSArray ?? []
        
            
            if status == true
            {
                
             if carParkArr.count > 0
             {
                let emaiDict = carParkArr[0] as? NSDictionary ?? [:]
                
                let emailStr = emaiDict["email"] as? String ?? ""
                
                self.emailBtn.setTitle(emailStr, for: .normal)
            }
                
                
            }
            else
            {
                TostErrorMessage(view:self.view,message:messageStr)
            }
           
            
        }) { (error) in
            TostErrorMessage(view:self.view,message:error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.setNavigationBarImage(for: nil, color: .black)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MAILComposerFunc
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
           let mailComposerVC = MFMailComposeViewController()
           mailComposerVC.mailComposeDelegate = self 
   
        mailComposerVC.setToRecipients([(emailBtn.titleLabel?.text!)!])
            mailComposerVC.setSubject("")
         mailComposerVC.setMessageBody("", isHTML: false)
   
          return mailComposerVC
       }

    func showSendMailErrorAlert() {
        
        TostErrorMessage(view: self.view, message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
       }

    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
   }
    
    //MARK:- IBAction
    
    @IBAction func emailBtnTap(_ sender: Any) {
        
        UIPasteboard.general.string = emailBtn.titleLabel?.text
        SucessMessage(view:self.view,message:"Copied Successfully")
       
        
//        let mailComposeViewController = configuredMailComposeViewController()
//            if MFMailComposeViewController.canSendMail() {
//                self.present(mailComposeViewController, animated: true, completion: nil)
//            } else
//            {
//            self.showSendMailErrorAlert()
//        }
    }
    
    
    @IBAction func crossTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
   

}

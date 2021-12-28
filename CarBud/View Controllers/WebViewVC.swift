//
//  WebViewVC.swift
//  CarBud
//
//  Created by kishlay kishore on 22/04/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {

 
    @IBOutlet weak var insideView: UIView!
    
    var webView: WKWebView!
    var getData:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: CGRect(x: 20, y: 0, width: insideView.bounds.width, height: insideView.bounds.height), configuration: WKWebViewConfiguration() )
       self.insideView.addSubview(webView)
    
       loadHtmlCode()
       
    }
    
    @IBAction func btnClosePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
   
    func loadHtmlCode() {
       
        webView.loadHTMLString(getData ?? "", baseURL: nil)
    }
  
}

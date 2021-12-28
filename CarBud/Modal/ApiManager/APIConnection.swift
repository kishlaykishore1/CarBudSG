//
//  APIConnection.swift
//  InstaHastag
//
//  Created by Snow-Macmini-2 on 09/05/19.
//  Copyright © 2019 Snow-Macmini-1. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class APIManager: NSObject {
    
    //POSTREQUEST--------AMITMISHRAIOSDEV--------------
    
    func postDatatoServer(_ strURL: String,parameter:NSDictionary, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        guard isInterNetConnected() == true else {
            TostErrorMessage(view:(UIApplication.shared.keyWindow)!,message:"Sorry we cannot reach the internet. Please check your connection.")
            return
        }
        
//        if strURL != searchParkingApi_endPoint
//        {
            showProgressHud(view: (UIApplication.shared.keyWindow)!)
//        }
        
        
        
        
        
        let finalUrl = baseUrl + strURL
        
        Alamofire.request(finalUrl, method: .post, parameters: parameter as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                dissmissHUD(UIApplication.shared.keyWindow!)
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                dissmissHUD(UIApplication.shared.keyWindow!)
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    //GETREQUEST_-------------------AMITMISHRACODE------------
    
    func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        guard isInterNetConnected() == true else {
            TostErrorMessage(view:(UIApplication.shared.keyWindow)!,message:"Sorry we cannot reach the internet. Please check your connection.")
            return
        }
        
        showProgressHud(view: (UIApplication.shared.keyWindow)!)
        let finalUrl = baseUrl + strURL
        Alamofire.request(finalUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                dissmissHUD(UIApplication.shared.keyWindow!)
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                dissmissHUD(UIApplication.shared.keyWindow!)
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    func requestUpload(_ strURL: String, with parameters: [String: Any]? = nil, files: [String: Any]? = nil , completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        let finalUrl = baseUrl + strURL
        showProgressHud(view: (UIApplication.shared.keyWindow)!)
        Alamofire.upload( multipartFormData: { multipartFormData in
            if let files = files {
                for (key, value) in files {
                    if let getImage = value as? UIImage {
                        let imageData = getImage.jpegData(compressionQuality: 0.5)
                        multipartFormData.append(imageData!, withName: key, fileName: "\(key).jpg", mimeType: "image/jpg")
                        
                        print("\(key).jpg")
                    }
                }
            }
            
            for (key, value) in parameters ?? [:]  {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!  , withName: key as String)
            }
        },to: finalUrl , method: .post , headers: nil,
          encodingCompletion: { encodingResult in
            let response: SessionManager.MultipartFormDataEncodingResult = encodingResult
            
//            dissmissHUD(UIApplication.shared.keyWindow!)
            switch response {
            case .success(let JSON,_,_):
                JSON.responseJSON { responseResult in
                    print(responseResult)
                    if responseResult.data != nil  {
                        print("Success with JSON: \(String(describing: String.init(data: responseResult.data!, encoding: String.Encoding.utf8)))")
                        _ = String.init(data: responseResult.data!, encoding: String.Encoding.utf8)
                    }
                    if responseResult.result.value == nil {
                        return ;
                    }
                    guard let response = responseResult.result.value as? [String: Any] else {
                        return
                    }
                    completionHandler!(response, nil)
                    
                }
            dissmissHUD(UIApplication.shared.keyWindow!)
            case .failure(let error):
                completionHandler!(nil, error as NSError?)
            }
        })
    }
}

class VersionCheck {
    
    public static let shared = VersionCheck()
    
    var newVersionAvailable: Bool?
    var appStoreVersion: String?
    
    func checkAppStore(callback: ((_ versionAvailable: Bool?, _ version: String?)->Void)? = nil) {
        let ourBundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        Alamofire.request("https://itunes.apple.com/lookup?bundleId=\(ourBundleId)").responseJSON { response in
            var isNew: Bool?
            var versionStr: String?
            
            if let json = response.result.value as? NSDictionary,
                let results = json["results"] as? NSArray,
                let entry = results.firstObject as? NSDictionary,
                let appVersion = entry["version"] as? String,
                let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                
            {
                
                isNew = ourVersion != appVersion
                versionStr = appVersion
            }
            
            self.appStoreVersion = versionStr
            self.newVersionAvailable = isNew
            callback?(isNew, versionStr)
        }
    }
}
extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}

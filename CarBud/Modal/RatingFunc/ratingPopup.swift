//
//  ratingPopup.swift
//  CarBud
//
//  Created by Snow-Macmini-2 on 23/08/19.
//  Copyright © 2019 Snow-Macmini-2. All rights reserved.
//

import Foundation
import StoreKit
extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
extension Date {
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}
func ratingPopupAppear()  {
    
    let savedDate = UserDefaults.standard.object(forKey: "DateSavedAfterAppInstall") as? Date
    
    let daysFromLaunch = Date().days(from: savedDate!)
    
    if daysFromLaunch >= 2  {
        UserDefaults.standard.set(Date(), forKey:"DateSavedAfterAppInstall")
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
           
        }
    }
    
    
    
}

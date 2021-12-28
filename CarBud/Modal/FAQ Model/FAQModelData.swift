//
//  FAQModelData.swift
//  CarBud
//
//  Created by kishlay kishore on 03/03/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import Foundation

// MARK: - FAQModelElement
struct FAQModelElement: Codable {
    let id: Int
    let orderID: Int?
    let question, answer: String
    var isExpanded : Bool? = false
    
    enum CodingKeys: String, CodingKey {
           case id
           case orderID = "order_id"
           case question, answer
       }
}


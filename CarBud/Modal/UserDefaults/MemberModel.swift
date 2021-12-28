//
//  MemberModel.swift
//  CarBud
//
//  Created by kishlay kishore on 02/04/20.
//  Copyright © 2020 Snow-Macmini-2. All rights reserved.
//

import Foundation

struct Defaults {

private static let userDefault = UserDefaults.standard
    
// MARK: - MemberModel
class MemberModel: Codable {
    let id: Int
    let firstName, lastName, email, password: String?
    let phoneNo: String?
    let carBrand,licensePlate: String
    let carModel : String
    let status: Int
    let confirmationCode,confirmcodeSendtime: String?
    let confirmed: Int
    let deviceToken: String?
    let isNotification: Int
    let rememberToken, operatorType: String?
    let createdBy, updatedBy: Int
    let createdAt, updatedAt, deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, password
        case phoneNo = "phone_no"
        case carBrand = "car_brand"
        case carModel = "car_model"
        case licensePlate = "license_plate"
        case status
        case confirmationCode = "confirmation_code"
        case confirmcodeSendtime = "confirmcode_sendtime"
        case confirmed
        case deviceToken = "device_token"
        case isNotification = "is_notification"
        case rememberToken = "remember_token"
        case operatorType = "operator_type"
        case createdBy = "created_by"
        case updatedBy = "updated_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
    
      static func storeMemberModel(value: [String: Any]) {
        userDefault.set(value, forKey: "Member")
            
        }
        
        static func getMemberModel() -> MemberModel? {
            if let getDate = userDefault.value(forKey: "Member") as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: getDate, options: .prettyPrinted)
                    do {
                        let decoder = JSONDecoder()
                        return try decoder.decode(MemberModel.self, from: jsonData)
                        
                    } catch let err {
                        print("Err", err)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            return nil
        }
    }
}

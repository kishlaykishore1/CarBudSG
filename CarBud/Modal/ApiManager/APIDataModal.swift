//
//  APIDataModal.swift
//  CarBud
//
//  Created by Snow-Macmini-2 on 30/07/19.
//  Copyright © 2019 Snow-Macmini-2. All rights reserved.
//

import Foundation
import UIKit

class searchDataModal {
    var latitude = Double()
    var longitude = Double()
    var carParkingID = Int()
    var average_parking_charges = String()
    
    init(Data:[String:Any]) {
        let location = Data["carpark"] as? NSDictionary ?? [:]
        self.latitude = Data["x_coordinate"] as? Double ?? 0.0
        self.longitude = Data["y_coordinate"] as? Double ?? 0.0
        self.average_parking_charges = location["average_parking_charges"] as? String ?? ""
        self.carParkingID = Data["car_park_id"] as? Int ?? 0
    }

    
}

func markerSte(value:String) -> String {
    var imageStr = String()
    
    switch value {
    case "1":
        imageStr = "marker"
    case "2":
           imageStr = "markerThree"
    case "3":
           imageStr = "markerOne"
        
    case "0":
        imageStr = "markerTwo"
    
    default:
           imageStr = "currentMarker"
    }
    
    return imageStr
}


class SearchKeyWordModal {
    var name = String()
    var latitude = String()
    var longitude = String()
    var carParkingID = String()
    var GoogleplaceID = String()
    var SPlaceText = String()
    
    init(data:[String:Any]) {
        self.name = data["name"] as? String ?? ""
        let location = data["location"] as? NSDictionary ?? [:]
        self.latitude = location["x_coordinate"] as? String ?? ""
        self.longitude = location["y_coordinate"] as? String ?? ""
        self.carParkingID = data ["car_park_id"] as? String ?? ""
        self.GoogleplaceID = data ["placeId"] as? String ?? ""
        self.SPlaceText = data ["GoogleScondaryText"] as? String ?? ""
    }
    
}

class Section {
    var name: String
    var items: [NSDictionary]
    
    
    init(name: String, items: [NSDictionary]) {
        self.name = name
        self.items = items
    }
}

// MARK: - MapCategoryModelElement
struct MapCategoryModelElement: Codable {
    let id: Int
    let name: String
    let mapCategoryModelDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case mapCategoryModelDescription = "description"
    }
}

// MARK: - QuotationCategoryModelElement
struct QuotationCategoryModelElement: Codable {
    let id: Int
    let categoryName, commentForDescription, commentForPhoto: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryName = "CategoryName"
        case commentForDescription = "CommentForDescription"
        case commentForPhoto = "CommentForPhoto"
    }
}

// MARK: - ServiceCategoryModelElement
struct ServiceCategoryModelElement: Codable {
    let id: Int
    let categoryName, remarks: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryName = "CategoryName"
        case remarks = "Remarks"
    }
}

// MARK: - OnsiteServicesModelElement
struct OnsiteServicesModelElement: Codable {
    let id: Int
    let company, contactNumber : String
    let operatingHours: String

    enum CodingKeys: String, CodingKey {
        case id
        case company = "Company"
        case contactNumber = "ContactNumber"
        case operatingHours = "OperatingHours"
    }
}

// MARK: - RetriveaccountModel
struct RetriveaccountModel: Codable {
    let code: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case code
        case userID = "user_id"
    }
}

// MARK: - VerifyAccountModel
struct VerifyAccountModel: Codable {
    let id: Int
    let firstName, lastName, email, password: String
    let phoneNo: String?
    let carBrand, carModel, licensePlate: String
    let status: Int
    let confirmationCode: String
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
}

// MARK: - QuotationListElement
struct QuotationListElement: Codable {
    let id, quotationRequestID, merchantID: Int
    let quotedItem: String
    let quantityQuoted, stockOnHand: Int?
    let unitCost, totalCost, priceExpiryDate: String?
    let merchantRemarks:String?
    let photos: String?
    let outletID: Int?
    let appointment, rejectionReason: String?
    let status: Int
    let createdAt, updatedAt: String?
    let merchant: Merchant

    enum CodingKeys: String, CodingKey {
        case id
        case quotationRequestID = "QuotationRequestID"
        case merchantID = "MerchantID"
        case quotedItem = "QuotedItem"
        case quantityQuoted = "QuantityQuoted"
        case stockOnHand = "StockOnHand"
        case unitCost = "UnitCost"
        case totalCost = "TotalCost"
        case priceExpiryDate = "PriceExpiryDate"
        case merchantRemarks = "MerchantRemarks"
        case photos = "Photos"
        case outletID = "OutletID"
        case appointment = "Appointment"
        case rejectionReason = "RejectionReason"
        case status = "Status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case merchant
    }
}

// MARK: - Merchant
struct Merchant: Codable {
    let id: Int
    let companyName, officeAddress, contactPerson, contactNumber: String
    let email, customerServiceNumber: String
    let acraProfile: String?
    let isActive: Int
    let approvedOn, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case companyName = "CompanyName"
        case officeAddress = "OfficeAddress"
        case contactPerson = "ContactPerson"
        case contactNumber = "ContactNumber"
        case email = "Email"
        case customerServiceNumber = "CustomerServiceNumber"
        case acraProfile = "ACRAProfile"
        case isActive = "IsActive"
        case approvedOn = "ApprovedOn"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - SupportNumberModelElement
struct SupportNumberModelElement: Codable {
    let whatsappNumber: String

    enum CodingKeys: String, CodingKey {
        case whatsappNumber = "whatsapp_number"
    }
}

// MARK: - QuotationDetailsModel
struct QuotationDetailsModel: Codable {
    let id, quotationRequestID, merchantID: Int?
    let quotedItem: String?
    let quantityQuoted, stockOnHand: Int?
    let unitCost, totalCost, priceExpiryDate: String?
    let merchantRemarks: String?
    let photos: String?
    let outletID: Int?
    var appointment: String? = ""
    var rejectionReason: String? = ""
    let status: Int?
    let createdAt, updatedAt: String?
    let merchant: Merchant

    enum CodingKeys: String, CodingKey {
        case id
        case quotationRequestID = "QuotationRequestID"
        case merchantID = "MerchantID"
        case quotedItem = "QuotedItem"
        case quantityQuoted = "QuantityQuoted"
        case stockOnHand = "StockOnHand"
        case unitCost = "UnitCost"
        case totalCost = "TotalCost"
        case priceExpiryDate = "PriceExpiryDate"
        case merchantRemarks = "MerchantRemarks"
        case photos = "Photos"
        case outletID = "OutletID"
        case appointment = "Appointment"
        case rejectionReason = "RejectionReason"
        case status = "Status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case merchant
    }
}

//// MARK: - Merchant
//struct Merchant: Codable {
//    let id: Int
//    let companyName, officeAddress, contactPerson, contactNumber: String
//    let email, customerServiceNumber, acraProfile: String
//    let isActive: Int
//    let approvedOn, createdAt, updatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case companyName = "CompanyName"
//        case officeAddress = "OfficeAddress"
//        case contactPerson = "ContactPerson"
//        case contactNumber = "ContactNumber"
//        case email = "Email"
//        case customerServiceNumber = "CustomerServiceNumber"
//        case acraProfile = "ACRAProfile"
//        case isActive = "IsActive"
//        case approvedOn = "ApprovedOn"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
// MARK: - UsersQuotationModelElement
struct UsersQuotationModelElement: Codable {
    let id, userID, categoryID: Int
    let requestDate: String
    let usersQuotationModelDescription: String?
    let quantity: Int
    let photo: String?
    let status, merchantID: Int
    let createdAt, updatedAt: String
    let noOfQuotes, requestStatus: Int
    let quotationTypeCategory: QuotationTypeCategory

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case categoryID = "category_id"
        case requestDate = "request_date"
        case usersQuotationModelDescription = "description"
        case photo = "Photo"
        case quantity, status
        case merchantID = "merchant_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case noOfQuotes = "no_of_quotes"
        case requestStatus = "request_status"
        case quotationTypeCategory = "quotation_type_category"
    }
}

// MARK: - QuotationTypeCategory
struct QuotationTypeCategory: Codable {
    let id: Int
    let categoryName, commentForDescription, commentForPhoto: String
    let remarks: String?
    let isActive: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryName = "CategoryName"
        case commentForDescription = "CommentForDescription"
        case commentForPhoto = "CommentForPhoto"
        case remarks = "Remarks"
        case isActive = "IsActive"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - MerchantOutletModelElement
struct MerchantOutletModelElement: Codable {
    let id, merchantID: Int
    let address: String
    let xCoordinate, yCoordinate: String?
    let operatingHours, contactNumber: String?
    let remarks: String?
    let isActive: Int
    let createdAt, updatedAt: String
    let merchant: Merchant

    enum CodingKeys: String, CodingKey {
        case id
        case merchantID = "MerchantID"
        case address = "Address"
        case xCoordinate = "XCoordinate"
        case yCoordinate = "YCoordinate"
        case operatingHours = "OperatingHours"
        case contactNumber = "ContactNumber"
        case remarks = "Remarks"
        case isActive = "IsActive"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case merchant
    }
}

//// MARK: - Merchant
//struct Merchant: Codable {
//    let id: Int
//    let companyName, officeAddress, contactPerson, contactNumber: String
//    let email, customerServiceNumber: String
//    let acraProfile: String?
//    let isActive: Int
//    let approvedOn, createdAt, updatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case companyName = "CompanyName"
//        case officeAddress = "OfficeAddress"
//        case contactPerson = "ContactPerson"
//        case contactNumber = "ContactNumber"
//        case email = "Email"
//        case customerServiceNumber = "CustomerServiceNumber"
//        case acraProfile = "ACRAProfile"
//        case isActive = "IsActive"
//        case approvedOn = "ApprovedOn"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}

// MARK: - ServiceDataByCategoryElement
struct ServiceDataByCategoryElement: Codable {
    let id, carServiceCategoryID: Int?
    let title: String
    let subTitle: String?
    let iconFile, details, address: String?
    let xCoordinate, yCoordinate: Double?
    let isActive: Int
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case carServiceCategoryID = "CarServiceCategoryID"
        case title = "Title"
        case subTitle = "SubTitle"
        case iconFile = "IconFile"
        case details = "Details"
        case address
        case xCoordinate = "XCoordinate"
        case yCoordinate = "YCoordinate"
        case isActive = "IsActive"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//enum AtedAt: String, Codable {
//    case the20200302114100 = "2020-03-02 11:41:00"
//    case the20200312152246 = "2020-03-12 15:22:46"
//}
//
//enum Title: String, Codable {
//    case caltex = "Caltex"
//    case esso = "Esso"
//    case shell = "Shell"
//    case spc = "SPC"
//}

// MARK: - NewProfileDataModel
struct NewProfileDataModel: Codable {
    let id: Int
    let firstName, lastName, email, password: String
    let phoneNo: String?
    let carBrand, carModel, licensePlate: String
    let status: Int
    let confirmationCode: String
    let confirmed: Int
    let deviceToken: String
    let isNotification: Int
    let rememberToken, operatorType: String
    let createdBy, updatedBy: Int
    let createdAt, updatedAt, deletedAt: String

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
}

// MARK: - AdminSettingModel
struct AdminSettingModel: Codable {
    let id, quotationRequest: Int
    let launchMessage: String
    let launchMessageDatetime, whatsappNumber, notificationEmail: String?
    let appMessage, quotationConfirmed, quotationRejected, logo: String?
    let favicon, seoTitle, seoKeyword, seoDescription: String?
    let companyContact, companyAddress, fromName, fromEmail: String?
    let facebook, linkedin, twitter, google: String?
    let copyrightText, footerText, terms, disclaimer: String?
    let googleAnalytics, homeVideo1, homeVideo2, homeVideo3: String?
    let homeVideo4, explanation1, explanation2, explanation3: String?
    let explanation4, createdAt, updatedAt: String?
    let isMessageExpired: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case quotationRequest = "quotation_request"
        case launchMessage = "launch_message"
        case launchMessageDatetime = "launch_message_datetime"
        case whatsappNumber = "whatsapp_number"
        case notificationEmail = "notification_email"
        case appMessage = "app_message"
        case quotationConfirmed = "quotation_confirmed"
        case quotationRejected = "quotation_rejected"
        case logo, favicon
        case seoTitle = "seo_title"
        case seoKeyword = "seo_keyword"
        case seoDescription = "seo_description"
        case companyContact = "company_contact"
        case companyAddress = "company_address"
        case fromName = "from_name"
        case fromEmail = "from_email"
        case facebook, linkedin, twitter, google
        case copyrightText = "copyright_text"
        case footerText = "footer_text"
        case terms, disclaimer
        case googleAnalytics = "google_analytics"
        case homeVideo1 = "home_video1"
        case homeVideo2 = "home_video2"
        case homeVideo3 = "home_video3"
        case homeVideo4 = "home_video4"
        case explanation1, explanation2, explanation3, explanation4
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isMessageExpired = "is_message_expired"
    }
}

// MARK: - UserActiveStatusModel
struct UserActiveStatusModel: Codable {
    let userStatus: Int

    enum CodingKeys: String, CodingKey {
        case userStatus = "user_status"
    }
}


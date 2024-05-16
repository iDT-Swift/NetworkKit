//
//  File.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation
@testable import NetworkKit

extension URLRequest.Response {
    public
    struct Employee: Codable, Hashable, Sendable, Identifiable {
        public
        enum EmployeeType: String, Sendable, Codable {
            case fullTime = "FULL_TIME"
            case partTime = "PART_TIME"
            case contractor = "CONTRACTOR"
        }
        public var uuid: String // Unique
        public var fullName: String
        public var phoneNumber: String?
        public var emailAddress: String
        public var biography: String?
        public var photoUrlSmall: String?
        public var photoUrlLarge: String?
        public var team: String
        public var employeeType: EmployeeType
        public var id: String { uuid }
        
        enum CodingKeys: String, CodingKey {
            case uuid = "uuid"
            case fullName = "full_name"
            case phoneNumber = "phone_number"
            case emailAddress = "email_address"
            case biography = "biography"
            case photoUrlSmall = "photo_url_small"
            case photoUrlLarge = "photo_url_large"
            case team = "team"
            case employeeType = "employee_type"
        }
        public
        init(uuid: String,
             fullName: String,
             phoneNumber: String? = nil,
             emailAddress: String,
             biography: String? = nil,
             photoUrlSmall: String? = nil,
             photoUrlLarge: String? = nil,
             team: String,
             employeeType: EmployeeType) {
            self.uuid = uuid
            self.fullName = fullName
            self.phoneNumber = phoneNumber
            self.emailAddress = emailAddress
            self.biography = biography
            self.photoUrlSmall = photoUrlSmall
            self.photoUrlLarge = photoUrlLarge
            self.team = team
            self.employeeType = employeeType
        }
    }
    
    public 
    struct Employees: Codable, Hashable, Sendable {
        var employees: [Employee]
    }
}

//
//  Contact.swift
//  iContact
//
//  Created by venbq8 on 4/10/19.
//  Copyright © 2019 Gaurav Rastogi. All rights reserved.
//

import UIKit

struct Contact: AppCodable {
    var id:String?
    var firstName:String?
    var lastName:String?
    var email:String?
    var phone:String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "firstName"
        case lastName = "lastName"
        case email = "email"
        case phone = "phone"
    }
    
    init(id: String = "", firstName: String = "", lastName: String = "", email: String = "", phone: String = "", image: String = "") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
    }
}

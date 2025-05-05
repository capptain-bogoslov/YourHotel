//
//  Data.swift
//  YourHotel
//
//  Created by Batsioulas, Theologos on 25/3/25.
//
import Foundation
import FirebaseFirestore
import SwiftUI


struct User: Codable {
    @DocumentID var id: String?
    var email: String
    var phone: String
    var authenticationMethod: String
    var dateCreated: String
    var room: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case phone
        case authenticationMethod = "authentication_method"
        case dateCreated = "date_created"
        case room
    }
}

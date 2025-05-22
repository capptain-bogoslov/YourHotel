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

struct Room: Codable {
    var requests: [RoomRequest]
}

struct RoomRequest: Codable, Hashable {
    var id: String
    var date: Date
    var requestMessage: String
    var userContact: String
    var userId: String
    
    
    enum CodingKeys: String, CodingKey {
        case date
        case requestMessage = "request"
        case userContact = "user"
        case userId = "userId"
        case id = "request_id"
    }
}


enum CustomError: Error, LocalizedError {
    
    case genericError
    case userNotFound
    
    var localizedDescription: String {
        switch self {
        case .genericError:
            return "Something went wrong"
        case .userNotFound:
            return "User not found"
        }
    }
    
}

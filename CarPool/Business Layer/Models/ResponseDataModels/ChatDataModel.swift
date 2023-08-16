//
//  ChatDataModel.swift
//  CarPool
//
//  Created by Himanshu on 8/10/23.
//

import Foundation

import Foundation

// MARK: - ChatData
struct ChatData: Codable {
    let code: Int
    let chat: SingleChat?
    let chats: [Chat]?
    let messages: [Message]?
}

struct SingleChat: Codable {
    let id, senderID, receiverID, publishID: Int
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case receiverID = "receiver_id"
        case senderID = "sender_id"
        case publishID = "publish_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Message
struct Message: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(UUID())
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    let id: Int
    let content: String
    let senderID, receiverID: Int
    let createdAt, updatedAt: String
    let chatID: Int

    enum CodingKeys: String, CodingKey {
        case id, content
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case chatID = "chat_id"
    }
}

// MARK: - Chat
struct Chat: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(UUID())
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    let id, receiverID, senderID, publishID: Int
    let publish: Publish
    let receiver, sender: Receiver
    let receiverImage: String
    let senderImage: String

    enum CodingKeys: String, CodingKey {
        case id
        case receiverID = "receiver_id"
        case senderID = "sender_id"
        case publishID = "publish_id"
        case publish, receiver, sender
        case receiverImage = "receiver_image"
        case senderImage = "sender_image"
    }
}

// MARK: - Receiver
struct Receiver: Codable {
    let id: Int
    let email, createdAt, updatedAt, jti: String
    let firstName, lastName, dob, title: String
    let phoneNumber: String?
    let bio: String?
    let travelPreferences, postalAddress: String?
    let activationDigest: String
    let activated: Bool?
    let activatedAt: String?
    let activateToken: String
    let sessionKey: String?
    let averageRating: String?
    let otp: Int
    let phoneVerified: Bool?

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case jti
        case firstName = "first_name"
        case lastName = "last_name"
        case dob, title
        case phoneNumber = "phone_number"
        case bio
        case travelPreferences = "travel_preferences"
        case postalAddress = "postal_address"
        case activationDigest = "activation_digest"
        case activated
        case activatedAt = "activated_at"
        case activateToken = "activate_token"
        case sessionKey = "session_key"
        case averageRating = "average_rating"
        case otp
        case phoneVerified = "phone_verified"
    }
}

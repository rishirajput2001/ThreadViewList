//
//  Model.swift
//  ListDemo
//
//  Created by Pushpendra Rajput  on 23/04/25.
//

import Foundation

// MARK: - ThreadListResponse
struct ThreadListResponse: Decodable {
    let statusCode: Int
    let success: Bool
    let message: String
    let data: ThreadData
}

// MARK: - ThreadData
struct ThreadData: Decodable {
    let threads: [ThreadList]
}

// MARK: - ThreadList
struct ThreadList: Decodable {
    let id: Int
    let patientUUID: String
    let parentID: Int
    let userID: Int
    let message: String
    let mentionsJSON: [Int]?
    let reactionsJSON: [String: [String: String]]?
    let attachmentsJson: [Attachment]?
    let isEdited: Int
    let lastEditTime: String?
    let createdAt: String
    let updatedAt: String
    let user: User
    let mentionList: [Mention]
    let replies: [ThreadList]
    let reactions: [Reaction]?

    enum CodingKeys: String, CodingKey {
        case id
        case patientUUID = "patient_uuid"
        case parentID = "parent_id"
        case userID = "user_id"
        case message
        case mentionsJSON = "mentions_json"
        case reactionsJSON = "reactions_json"
        case attachmentsJson = "attachments_json"
        case isEdited = "is_edited"
        case lastEditTime = "last_edit_time"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case mentionList = "mention_list"
        case replies
        case reactions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        patientUUID = try container.decode(String.self, forKey: .patientUUID)
        parentID = try container.decode(Int.self, forKey: .parentID)
        userID = try container.decode(Int.self, forKey: .userID)
        message = try container.decode(String.self, forKey: .message)
        mentionsJSON = try container.decodeIfPresent([Int].self, forKey: .mentionsJSON) ?? []

        reactionsJSON = try container.decodeIfPresent([String: [String: String]].self, forKey: .reactionsJSON)
        attachmentsJson = try container.decodeIfPresent([Attachment].self, forKey: .attachmentsJson)
        isEdited = try container.decode(Int.self, forKey: .isEdited)
        lastEditTime = try container.decodeIfPresent(String.self, forKey: .lastEditTime)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        user = try container.decode(User.self, forKey: .user)
        mentionList = try container.decode([Mention].self, forKey: .mentionList)
        replies = try container.decodeIfPresent([ThreadList].self, forKey: .replies) ?? []
        reactions = try container.decodeIfPresent([Reaction].self, forKey: .reactions)
    }
}

// MARK: - User
struct User: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let profilePic: String?
    let professionalTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case professionalTitle = "professional_title"
    }
}

// MARK: - Mention
struct Mention: Decodable {
    let id: Int
    let name: String
}

// MARK: - Attachment
struct Attachment: Decodable {
    let fileName: String
    let fileOriginalName: String

    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case fileOriginalName = "file_original_name"
    }
}

// MARK: - Reaction
struct Reaction: Decodable {
    let emoji: String
    let users: [ReactionUser]
}

// MARK: - ReactionUser
struct ReactionUser: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let profilePic: String?
    let professionalTitle: String
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case professionalTitle = "professional_title"
        case timestamp
    }
}

// MARK: - extension ThreadList
extension ThreadList {
    init(id: Int, message: String, mentionList: [Mention], attachmentsJson: [Attachment]?, user: User, replies: [ThreadList]) {
        self.id = id
        self.patientUUID = ""
        self.parentID = 0
        self.userID = user.id
        self.message = message
        self.mentionsJSON = []
        self.reactionsJSON = nil
        self.attachmentsJson = attachmentsJson
        self.isEdited = 0
        self.lastEditTime = nil
        self.createdAt = ""
        self.updatedAt = ""
        self.user = user
        self.mentionList = mentionList
        self.replies = replies
        self.reactions = nil
    }
}

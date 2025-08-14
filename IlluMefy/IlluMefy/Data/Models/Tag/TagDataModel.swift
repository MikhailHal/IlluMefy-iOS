//
//  TagDataModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/14.
//

struct TagDataModel: Codable {
    let id: String
    let name: String
    let description: String
    let viewCount: Int
    let createdAt: FirebaseTimestamp
    let updatedAt: FirebaseTimestamp
}

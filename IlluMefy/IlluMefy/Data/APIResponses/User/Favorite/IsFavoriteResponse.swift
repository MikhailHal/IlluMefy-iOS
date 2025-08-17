//
//  IsFavoriteResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/17.
//

struct IsFavoriteResponse: Codable {
    let data: IsFavoriteData
}

struct IsFavoriteData: Codable {
    let isFavorite: Bool
}

//
//  YouTubeChannelDataModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/12.
//

struct YouTubeChannelDataModel: Codable {
    /// YouTube上のユーザー名
    let username: String
    /// YouTubeチャンネルID
    let channelId: String
    /// チャンネル登録者数
    let subscriberCount: Int
    /// 総視聴回数
    let viewCount: Int?
}

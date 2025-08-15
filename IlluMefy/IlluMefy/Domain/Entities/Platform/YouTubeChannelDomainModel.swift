//
//  YouTubeChannelDomainModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/15.
//
import Foundation
struct YouTubeChannelDomainModel: Equatable, Codable, Hashable {
    // MARK: プロパティ
    /// チャンネルID
    let channelId: String
    /// チャンネル名
    let channelName: String
    /// 登録者数
    let subscriberCount: Int
    /// 再生回数
    let numberOfViews: Int
    
    // MARK: 振る舞い
    /// チャンネルURL
    func channelUrl() -> URL {
        URL(string: "https://www.youtube.com/channel/\(channelId)")!
    }
    
    /// プラットフォームアイコン
    func platformIcon() -> String {
        return "play.rectangle.fill"
    }
}

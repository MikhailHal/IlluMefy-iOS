//
//  GetPopularCreatorsResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/10.
//

import Foundation

struct GetPopularCreatorsResponse: Codable {
    let data: [CreatorDataModel]
}

/// プラットフォーム情報のレスポンス
struct PlatformsResponse: Codable {
    /// YouTube チャンネル情報
    let youtube: YouTubeChannelDataModel?
    
    /// Twitch 情報
    let twitch: SocialLinkPlatform?
    
    /// TikTok 情報
    let tiktok: SocialLinkPlatform?
    
    /// Instagram 情報
    let instagram: SocialLinkPlatform?
    
    /// ニコニコ動画 情報
    let niconico: SocialLinkPlatform?
}

/// ソーシャルリンクのみを持つプラットフォーム情報
struct SocialLinkPlatform: Codable {
    /// プロフィールへのリンク
    let socialLink: String
}

/// Firebase Timestampの構造
struct FirebaseTimestamp: Codable {
    let _seconds: Int
    let _nanoseconds: Int
    
    /// DateオブジェクトへのConverter
    var toDate: Date {
        let timeInterval = TimeInterval(_seconds) + TimeInterval(_nanoseconds) / 1_000_000_000
        return Date(timeIntervalSince1970: timeInterval)
    }
}

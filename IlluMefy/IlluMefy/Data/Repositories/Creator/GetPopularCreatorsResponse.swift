//
//  GetPopularCreatorsResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/10.
//

import Foundation

/// getPopularCreatorsのレスポンス
struct GetPopularCreatorsResponse: Codable {
    let data: [CreatorResponse]
}

/// バックエンドから返されるCreator情報
struct CreatorResponse: Codable {
    /// Firestore ドキュメントID
    let id: String
    
    /// クリエイター名
    let name: String
    
    /// プロフィール画像のURL
    let profileImageUrl: String
    
    /// クリエイターの説明文
    let description: String
    
    /// お気に入り登録数
    let favoriteCount: Int
    
    /// 各プラットフォームの情報
    let platforms: PlatformsResponse
    
    /// 直接設定されたタグIDの配列
    let tags: [String]
    
    /// 表示用のタグ名配列
    let tagNames: [String]
    
    /// 作成日時
    let createdAt: FirebaseTimestamp
    
    /// 更新日時
    let updatedAt: FirebaseTimestamp
}

/// プラットフォーム情報のレスポンス
struct PlatformsResponse: Codable {
    /// YouTube チャンネル情報
    let youtube: YouTubePlatform?
    
    /// Twitch 情報
    let twitch: SocialLinkPlatform?
    
    /// TikTok 情報
    let tiktok: SocialLinkPlatform?
    
    /// Instagram 情報
    let instagram: SocialLinkPlatform?
    
    /// ニコニコ動画 情報
    let niconico: SocialLinkPlatform?
}

/// YouTube プラットフォーム情報
struct YouTubePlatform: Codable {
    /// YouTube上のユーザー名
    let username: String
    
    /// YouTubeチャンネルID
    let channelId: String
    
    /// チャンネル登録者数
    let subscriberCount: Int
    
    /// 総視聴回数
    let viewCount: Int?
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

// MARK: - Converter Extension

extension CreatorResponse {
    /// CreatorResponseからドメインのCreatorエンティティへ変換
    func toCreator() -> Creator {
        // プラットフォームURLマップの構築
        var platformMap: [Platform: String] = [:]
        
        // YouTube
        if let youtube = platforms.youtube {
            let youtubeUrl = "https://youtube.com/@\(youtube.username)"
            platformMap[.youtube] = youtubeUrl
        }
        
        // Twitch
        if let twitch = platforms.twitch {
            platformMap[.twitch] = twitch.socialLink
        }
        
        // TikTok
        if let tiktok = platforms.tiktok {
            platformMap[.tiktok] = tiktok.socialLink
        }
        
        // Instagram
        if let instagram = platforms.instagram {
            platformMap[.instagram] = instagram.socialLink
        }
        
        // ニコニコ動画
        if let niconico = platforms.niconico {
            platformMap[.niconico] = niconico.socialLink
        }
        
        // プラットフォームクリック率（バックエンドにないので均等配分）
        var platformClickRatio: [Platform: Double] = [:]
        let platformCount = Double(platformMap.count)
        if platformCount > 0 {
            let ratio = 1.0 / platformCount
            for platform in platformMap.keys {
                platformClickRatio[platform] = ratio
            }
        }
        
        return Creator(
            id: "creator_001",
            name: "ゲーム実況者A",
            thumbnailUrl: "https://picsum.photos/200/200?random=1",
            socialLinkClickCount: 1500,
            tag: ["tag_007", "tag_011"],
            description: "FPSゲームをメインに実況しています。毎日20時から配信！",
            platform: [
                .youtube: "https://youtube.com/@gameplayerA",
                .twitch: "https://twitch.tv/gameplayerA",
                .x: "https://twitter.com/gameplayerA"
            ],
            createdAt: Date().addingTimeInterval(-86400 * 30),
            updatedAt: Date().addingTimeInterval(-3600),
            favoriteCount: 100
        )
    }
}

//
//  CreatorDataModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/12.
//
import Foundation
struct CreatorDataModel: Codable {
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

extension CreatorDataModel {
    /// CreatorDataModelからドメインのCreatorエンティティへ変換
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
        
        return Creator(
            id: id,
            name: name,
            thumbnailUrl: profileImageUrl,
            socialLinkClickCount: 0,
            tag: tags,
            description: description,
            platform: platformMap,
            createdAt: createdAt.toDate,
            updatedAt: updatedAt.toDate,
            favoriteCount: favoriteCount
        )
    }
}

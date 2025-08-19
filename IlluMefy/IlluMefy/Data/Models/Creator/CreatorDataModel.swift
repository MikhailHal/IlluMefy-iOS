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
        
        // YouTubeチャンネル情報の構築
        var youtubeChannel: YouTubeChannelDomainModel?
        if let youtube = platforms.youtube {
            youtubeChannel = YouTubeChannelDomainModel(
                channelId: youtube.channelId,
                channelName: youtube.username,
                subscriberCount: youtube.subscriberCount,
                numberOfViews: youtube.viewCount
            )
        }
        
        return Creator(
            id: id,
            name: name,
            thumbnailUrl: profileImageUrl,
            socialLinkClickCount: 0,
            tag: tags,
            description: description,
            youtube: youtubeChannel,
            createdAt: createdAt.toDate,
            updatedAt: updatedAt.toDate,
            favoriteCount: favoriteCount
        )
    }
}

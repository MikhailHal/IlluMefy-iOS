//
//  MockCreatorDetailData.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// CreatorDetail画面のプレビュー用モックデータ
struct MockCreatorDetailData {
    
    /// プレビュー用のクリエイターデータ
    static let sampleCreator = Creator(
        id: "creator_001",
        name: "ゲーム実況者A",
        thumbnailUrl: "https://picsum.photos/200/200?random=1",
        socialLinkClickCount: 1500,
        tag: ["tag_007", "tag_011"],
        description: "FPSゲームをメインに実況しています。毎日20時から配信！",
        youtube: YouTubeChannelDomainModel(
            channelId: "UCgameplayerA",
            channelName: "gameplayerA",
            subscriberCount: 150000,
            numberOfViews: 5000000
        ),
        createdAt: Date().addingTimeInterval(-86400 * 30),
        updatedAt: Date().addingTimeInterval(-3600),
        favoriteCount: 100
    )
    
    /// プレビュー用の類似クリエイターデータ
    static let similarCreators = [
        Creator(
            id: "creator_002",
            name: "VTuber B",
            thumbnailUrl: "https://picsum.photos/200/200?random=2",
            socialLinkClickCount: 2000,
            tag: ["tag_009", "tag_007"],
            description: "歌ってゲームして楽しく配信してます♪",
            youtube: YouTubeChannelDomainModel(
                channelId: "UCvtuberB",
                channelName: "vtuberB",
                subscriberCount: 200000,
                numberOfViews: 8000000
            ),
            createdAt: Date().addingTimeInterval(-86400 * 60),
            updatedAt: Date().addingTimeInterval(-7200),
            favoriteCount: 150
        ),
        Creator(
            id: "creator_003",
            name: "プロゲーマーC",
            thumbnailUrl: "https://picsum.photos/200/200?random=3",
            socialLinkClickCount: 4000,
            tag: ["tag_007", "tag_005"],
            description: "プロゲーマーとして活動中。大会実績多数。",
            youtube: YouTubeChannelDomainModel(
                channelId: "UCprogamerC",
                channelName: "progamerC",
                subscriberCount: 400000,
                numberOfViews: 15000000
            ),
            createdAt: Date().addingTimeInterval(-86400 * 90),
            updatedAt: Date().addingTimeInterval(-86400),
            favoriteCount: 200
        ),
        Creator(
            id: "creator_004",
            name: "カジュアル実況D",
            thumbnailUrl: "https://picsum.photos/200/200?random=4",
            socialLinkClickCount: 500,
            tag: ["tag_001", "tag_013"],
            description: "マイクラ建築をまったり実況。初心者歓迎！",
            youtube: nil,
            createdAt: Date().addingTimeInterval(-86400 * 45),
            updatedAt: Date().addingTimeInterval(-86400 * 5),
            favoriteCount: 75
        )
    ]
}

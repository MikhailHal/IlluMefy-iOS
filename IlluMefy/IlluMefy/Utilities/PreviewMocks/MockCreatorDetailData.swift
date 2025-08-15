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
        platform: [
            .youtube: "https://youtube.com/@gameplayerA",
            .twitch: "https://twitch.tv/gameplayerA",
            .x: "https://twitter.com/gameplayerA"
        ],
        youtube: nil,
        createdAt: Date().addingTimeInterval(-86400 * 30),
        updatedAt: Date().addingTimeInterval(-3600),
        favoriteCount: 100
    )
    
    /// プレビュー用の類似クリエイターデータ
    static let similarCreators = [
        Creator(
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
            youtube: nil,
            createdAt: Date().addingTimeInterval(-86400 * 30),
            updatedAt: Date().addingTimeInterval(-3600),
            favoriteCount: 100
        ),
        Creator(
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
            youtube: nil,
            createdAt: Date().addingTimeInterval(-86400 * 30),
            updatedAt: Date().addingTimeInterval(-3600),
            favoriteCount: 100
        ),
        Creator(
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
            youtube: nil,
            createdAt: Date().addingTimeInterval(-86400 * 30),
            updatedAt: Date().addingTimeInterval(-3600),
            favoriteCount: 100
        )
    ]
}

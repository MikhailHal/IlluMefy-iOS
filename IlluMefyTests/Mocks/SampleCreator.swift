//
//  SampleCreator.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
@testable import IlluMefy

enum SampleCreator {
    static let gamePlayerA = Creator(
        id: "creator_001",
        name: "ゲーム実況者A",
        thumbnailUrl: "https://picsum.photos/200/200?random=1",
        viewCount: 5000,
        socialLinkClickCount: 1500,
        platformClickRatio: [
            .youtube: 0.7,
            .twitch: 0.3
        ],
        relatedTag: ["fps", "apex-legends", "valorant"],
        description: "FPSゲームをメインに実況しています。毎日20時から配信！",
        platform: [
            .youtube: "https://youtube.com/@gameplayerA",
            .twitch: "https://twitch.tv/gameplayerA",
            .x: "https://twitter.com/gameplayerA"
        ],
        createdAt: Date().addingTimeInterval(-86400 * 30),
        updatedAt: Date().addingTimeInterval(-3600),
        isActive: true
    )
    
    static let vtuberB = Creator(
        id: "creator_002",
        name: "VTuber B",
        thumbnailUrl: "https://picsum.photos/200/200?random=2",
        viewCount: 9000,
        socialLinkClickCount: 2000,
        platformClickRatio: [
            .x: 0.6,
            .youtube: 0.4
        ],
        relatedTag: ["vtuber", "singing", "chatting"],
        description: "バーチャルYouTuberとして歌と雑談を中心に活動しています！",
        platform: [
            .youtube: "https://youtube.com/@vtuberB",
            .x: "https://twitter.com/vtuberB",
            .instagram: "https://instagram.com/vtuberB"
        ],
        createdAt: Date().addingTimeInterval(-86400 * 20),
        updatedAt: Date().addingTimeInterval(-1800),
        isActive: true
    )
    
    static let cookingCreatorC = Creator(
        id: "creator_003",
        name: "料理研究家C",
        thumbnailUrl: "https://picsum.photos/200/200?random=3",
        viewCount: 3500,
        socialLinkClickCount: 800,
        platformClickRatio: [
            .youtube: 0.8,
            .instagram: 0.2
        ],
        relatedTag: ["cooking", "recipe", "healthy"],
        description: "簡単で美味しい料理レシピを紹介しています。健康志向の方にもおすすめ！",
        platform: [
            .youtube: "https://youtube.com/@cookingC",
            .instagram: "https://instagram.com/cookingC"
        ],
        createdAt: Date().addingTimeInterval(-86400 * 45),
        updatedAt: Date().addingTimeInterval(-7200),
        isActive: true
    )
}
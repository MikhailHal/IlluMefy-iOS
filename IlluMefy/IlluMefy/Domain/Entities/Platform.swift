//
//  Platform.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

enum Platform: String, CaseIterable, Codable {
    case youtube
    case twitch
    case tiktok
    case instagram
    case x
    case discord
    case niconico
    
    var displayName: String {
        switch self {
        case .youtube:
            return "YouTube"
        case .twitch:
            return "Twitch"
        case .tiktok:
            return "TikTok"
        case .instagram:
            return "Instagram"
        case .x:
            return "X"
        case .discord:
            return "Discord"
        case .niconico:
            return "ニコニコ動画"
        }
    }
    
    var icon: String {
        switch self {
        // YouTubeだけロゴ使用許可申請欲しくてしたけどrejectされた...
        case .youtube:
            return "play.rectangle.fill"
        case .twitch:
            return Asset.Assets.PlatformIcons.Twitch.icon.name
        case .tiktok:
            return Asset.Assets.PlatformIcons.TikTok.icon.name
        case .instagram:
            return Asset.Assets.PlatformIcons.Instagram.icon.name
        case .x:
            return Asset.Assets.PlatformIcons.X.icon.name
        case .discord:
            return Asset.Assets.PlatformIcons.Discord.icon.name
        case .niconico:
            return Asset.Assets.PlatformIcons.Niconico.icon.name
        }
    }
}

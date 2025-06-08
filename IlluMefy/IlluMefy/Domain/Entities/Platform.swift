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
    case twitter
    case discord
    case niconico
    case mildom
    
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
        case .twitter:
            return "Twitter"
        case .discord:
            return "Discord"
        case .niconico:
            return "ニコニコ動画"
        case .mildom:
            return "Mildom"
        }
    }
    
    var icon: String {
        switch self {
        case .youtube:
            return Asset.Assets.PlatformIcons.Twitch.twitchIconSmall.name
        case .twitch:
            return Asset.Assets.PlatformIcons.Twitch.twitchIconSmall.name
        case .tiktok:
            return Asset.Assets.PlatformIcons.TikTok.tikTokIconSmall.name
        case .instagram:
            return Asset.Assets.PlatformIcons.Twitch.twitchIconSmall.name
        case .twitter:
            return Asset.Assets.PlatformIcons.Twitch.twitchIconSmall.name
        case .discord:
            return Asset.Assets.PlatformIcons.Twitch.twitchIconSmall.name
        case .niconico:
            return Asset.Assets.PlatformIcons.Twitch.twitchIconSmall.name
        case .mildom:
            return Asset.Assets.PlatformIcons.Twitch.twitchIconSmall.name
        }
    }
}

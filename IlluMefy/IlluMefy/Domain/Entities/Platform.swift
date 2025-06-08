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
}

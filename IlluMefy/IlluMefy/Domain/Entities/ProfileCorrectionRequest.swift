//
//  ProfileCorrectionRequest.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正依頼エンティティ
struct ProfileCorrectionRequest: Codable, Equatable {
    /// 申請ID
    let id: String
    
    /// 対象クリエイターID
    let creatorId: String
    
    /// 申請者ID（任意）
    let requesterId: String?
    
    /// 修正項目
    let correctionItems: [CorrectionItem]
    
    /// 修正理由
    let reason: String
    
    /// 参考URL
    let referenceUrl: String?
    
    /// 申請ステータス
    var status: Status
    
    /// 申請日時
    let requestedAt: Date
    
    /// 審査日時
    var reviewedAt: Date?
    
    /// 審査者ID
    var reviewerId: String?
    
    /// 審査コメント
    var reviewComment: String?
    
    /// 修正項目
    struct CorrectionItem: Codable, Equatable {
        let type: CorrectionType
        let currentValue: String
        let suggestedValue: String
    }
    
    /// 修正タイプ
    enum CorrectionType: String, Codable, CaseIterable {
        case creatorName
        case profileImage
        case youtube
        case twitch
        case tiktok
        case twitter
        case instagram
        case otherSns
        case tags
        case other
        
        var displayName: String {
            switch self {
            case .creatorName:
                return "クリエイター名"
            case .profileImage:
                return "プロフィール画像"
            case .youtube:
                return "YouTube"
            case .twitch:
                return "Twitch"
            case .tiktok:
                return "TikTok"
            case .twitter:
                return "X (Twitter)"
            case .instagram:
                return "Instagram"
            case .otherSns:
                return "その他SNS"
            case .tags:
                return "タグ"
            case .other:
                return "その他"
            }
        }
        
        var icon: String? {
            switch self {
            case .creatorName:
                return "person.fill"
            case .profileImage:
                return "camera.fill"
            case .youtube, .twitch, .tiktok, .twitter, .instagram, .otherSns:
                return "link"
            case .tags:
                return "tag.fill"
            case .other:
                return "ellipsis.circle.fill"
            }
        }
    }
    
    /// 申請ステータス
    enum Status: String, Codable {
        case pending
        case reviewing
        case approved
        case rejected
        
        var displayName: String {
            switch self {
            case .pending:
                return "審査待ち"
            case .reviewing:
                return "審査中"
            case .approved:
                return "承認済み"
            case .rejected:
                return "却下"
            }
        }
    }
}
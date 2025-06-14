//
//  TagApplicationRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// タグ申請リクエスト
struct TagApplicationRequest: Codable {
    /// 対象のクリエイターID
    let creatorId: String
    
    /// 申請するタグ名
    let tagName: String
    
    /// 申請理由（任意）
    let reason: String?
    
    /// 申請タイプ
    let applicationType: ApplicationType
    
    /// 申請日時
    let requestedAt: Date
    
    enum ApplicationType: String, Codable, CaseIterable {
        case remove
        case add
        
        var displayName: String {
            switch self {
            case .remove:
                return L10n.CreatorDetail.tagDeleteApplication
            case .add:
                return L10n.CreatorDetail.tagAddApplication
            }
        }
    }
    
    init(creatorId: String, tagName: String, reason: String? = nil, applicationType: ApplicationType = .add) {
        self.creatorId = creatorId
        self.tagName = tagName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.reason = reason?.isEmpty == false ? reason : nil
        self.applicationType = applicationType
        self.requestedAt = Date()
    }
}

/// タグ申請レスポンス
struct TagApplicationResponse: Codable {
    /// 申請ID
    let applicationId: String
    
    /// 申請状態
    let status: ApplicationStatus
    
    /// 申請受付日時
    let submittedAt: Date
    
    /// メッセージ（任意）
    let message: String?
    
    enum ApplicationStatus: String, Codable {
        case pending
        case approved
        case rejected
        
        var displayName: String {
            switch self {
            case .pending:
                return "審査中"
            case .approved:
                return "承認済み"
            case .rejected:
                return "却下"
            }
        }
    }
}

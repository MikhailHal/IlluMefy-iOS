//
//  TagApplicationRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// タグ申請Repository プロトコル
protocol TagApplicationRepositoryProtocol {
    /// タグ申請を保存
    func saveApplication(_ application: TagApplication) async throws -> TagApplication
    
    /// 申請履歴を取得
    func getApplicationHistory(for creatorId: String) async throws -> [TagApplication]
    
    /// 申請を取得
    func getApplication(id: String) async throws -> TagApplication?
}

/// タグ申請エンティティ
struct TagApplication {
    let id: String
    let creatorId: String
    let tagName: String
    let reason: String?
    let applicationType: TagApplicationRequest.ApplicationType
    let status: TagApplicationResponse.ApplicationStatus
    let requestedAt: Date
    let reviewedAt: Date?
    let reviewerId: String?
    let reviewComment: String?
}
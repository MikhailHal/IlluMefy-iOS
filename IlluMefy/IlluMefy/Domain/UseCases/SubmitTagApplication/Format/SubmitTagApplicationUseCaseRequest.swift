//
//  SubmitTagApplicationUseCaseRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// タグ申請送信 UseCase リクエスト
struct SubmitTagApplicationUseCaseRequest {
    /// 対象のクリエイターID
    let creatorId: String
    
    /// 申請するタグ名
    let tagName: String
    
    /// 申請理由（任意）
    let reason: String?
    
    /// 申請タイプ
    let applicationType: TagApplicationRequest.ApplicationType
    
    /// バリデーション
    func validate() throws {
        guard !creatorId.isEmpty else {
            throw SubmitTagApplicationUseCaseError.invalidCreatorId
        }
        
        guard !tagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SubmitTagApplicationUseCaseError.invalidTagName
        }
        
        guard tagName.count <= 50 else {
            throw SubmitTagApplicationUseCaseError.tagNameTooLong
        }
        
        if let reason = reason, reason.count > 200 {
            throw SubmitTagApplicationUseCaseError.reasonTooLong
        }
    }
}
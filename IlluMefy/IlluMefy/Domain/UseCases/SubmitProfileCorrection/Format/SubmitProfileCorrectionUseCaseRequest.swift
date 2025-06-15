//
//  SubmitProfileCorrectionUseCaseRequest.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正依頼送信ユースケースリクエスト
struct SubmitProfileCorrectionUseCaseRequest: Equatable {
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
    
    /// 修正項目
    struct CorrectionItem: Equatable {
        let type: ProfileCorrectionRequest.CorrectionType
        let currentValue: String
        let suggestedValue: String
    }
}

// MARK: - Validation Extension

extension SubmitProfileCorrectionUseCaseRequest {
    /// バリデーションエラー
    enum ValidationError: LocalizedError {
        case emptyCreatorId
        case emptyCorrectionItems
        case emptyReason
        case reasonTooLong
        case invalidUrl
        case emptyCorrectionValue(ProfileCorrectionRequest.CorrectionType)
        case correctionValueTooLong(ProfileCorrectionRequest.CorrectionType)
        
        var errorDescription: String? {
            switch self {
            case .emptyCreatorId:
                return "クリエイターIDが指定されていません"
            case .emptyCorrectionItems:
                return "修正項目を選択してください"
            case .emptyReason:
                return "修正理由を入力してください"
            case .reasonTooLong:
                return "修正理由は500文字以内で入力してください"
            case .invalidUrl:
                return "参考URLの形式が正しくありません"
            case .emptyCorrectionValue(let type):
                return "\(type.displayName)の値を入力してください"
            case .correctionValueTooLong(let type):
                return "\(type.displayName)の値が長すぎます"
            }
        }
    }
    
    /// リクエストのバリデーション
    func validate() throws {
        // クリエイターIDの検証
        if creatorId.isEmpty {
            throw ValidationError.emptyCreatorId
        }
        
        // 修正項目の検証
        if correctionItems.isEmpty {
            throw ValidationError.emptyCorrectionItems
        }
        
        // 理由の検証
        if reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidationError.emptyReason
        }
        
        if reason.count > 500 {
            throw ValidationError.reasonTooLong
        }
        
        // 参考URLの検証
        if let urlString = referenceUrl, !urlString.isEmpty {
            guard URL(string: urlString) != nil else {
                throw ValidationError.invalidUrl
            }
        }
        
        // 各修正項目の検証
        for item in correctionItems {
            try item.validate()
        }
    }
}

extension SubmitProfileCorrectionUseCaseRequest.CorrectionItem {
    /// 修正項目のバリデーション
    func validate() throws {
        // 現在の値の検証
        if currentValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw SubmitProfileCorrectionUseCaseRequest.ValidationError.emptyCorrectionValue(type)
        }
        
        // 修正後の値の検証
        if suggestedValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw SubmitProfileCorrectionUseCaseRequest.ValidationError.emptyCorrectionValue(type)
        }
        
        // 値の長さ制限
        let maxLength: Int
        switch type {
        case .creatorName:
            maxLength = 50
        case .profileImage, .youtube, .twitch, .tiktok, .twitter, .instagram, .otherSns:
            maxLength = 500
        case .tags:
            maxLength = 200
        case .other:
            maxLength = 300
        }
        
        if currentValue.count > maxLength || suggestedValue.count > maxLength {
            throw SubmitProfileCorrectionUseCaseRequest.ValidationError.correctionValueTooLong(type)
        }
    }
}
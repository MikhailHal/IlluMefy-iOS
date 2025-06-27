//
//  ContactSupport.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/27.
//

import Foundation

// MARK: - ContactSupport Entity
struct ContactSupport: Identifiable, Codable, Equatable {
    let id: String
    let type: ContactSupportType
    let content: String
    let submittedAt: Date
    let status: ContactSupportStatus
    let userId: String
    
    init(
        id: String = UUID().uuidString,
        type: ContactSupportType,
        content: String,
        submittedAt: Date = Date(),
        status: ContactSupportStatus = .pending,
        userId: String
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.submittedAt = submittedAt
        self.status = status
        self.userId = userId
    }
}

// MARK: - ContactSupportType
enum ContactSupportType: String, CaseIterable, Codable {
    case bugReport = "bug_report"
    case featureRequest = "feature_request"
    case usageQuestion = "usage_question"
    case accountIssue = "account_issue"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .bugReport:
            return "不具合の報告"
        case .featureRequest:
            return "機能追加の要望"
        case .usageQuestion:
            return "使い方に関する質問"
        case .accountIssue:
            return "アカウントの問題"
        case .other:
            return "その他"
        }
    }
    
    var icon: String {
        switch self {
        case .bugReport:
            return "exclamationmark.triangle.fill"
        case .featureRequest:
            return "lightbulb.fill"
        case .usageQuestion:
            return "questionmark.circle.fill"
        case .accountIssue:
            return "person.crop.circle.badge.exclamationmark"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
    
    var placeholder: String {
        switch self {
        case .bugReport:
            return "発生した問題の詳細、発生タイミング、使用環境などをお書きください"
        case .featureRequest:
            return "追加を希望する機能の詳細、利用シーンなどをお書きください"
        case .usageQuestion:
            return "わからない機能や操作についてお書きください"
        case .accountIssue:
            return "アカウントで発生している問題の詳細をお書きください"
        case .other:
            return "お問い合わせ内容を詳しくお書きください"
        }
    }
}

// MARK: - ContactSupportStatus
enum ContactSupportStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case reviewing = "reviewing"
    case resolved = "resolved"
    case closed = "closed"
    
    var displayName: String {
        switch self {
        case .pending:
            return "受付済み"
        case .reviewing:
            return "確認中"
        case .resolved:
            return "解決済み"
        case .closed:
            return "完了"
        }
    }
}

// MARK: - ContactSupportRequest
struct ContactSupportRequest: Codable {
    let type: ContactSupportType
    let content: String
    let userId: String
    
    init(type: ContactSupportType, content: String, userId: String) {
        self.type = type
        self.content = content
        self.userId = userId
    }
}

// MARK: - ContactSupportError
enum ContactSupportError: Error, LocalizedError {
    case invalidInput
    case invalidContent
    case networkError
    case unauthorized
    case serverError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "入力内容が無効です"
        case .invalidContent:
            return "お問い合わせ内容が不正です"
        case .networkError:
            return "ネットワーク接続を確認してください"
        case .unauthorized:
            return "認証が必要です"
        case .serverError:
            return "サーバーエラーが発生しました"
        case .unknown:
            return "予期しないエラーが発生しました"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .invalidInput:
            return "入力内容が無効です"
        case .invalidContent:
            return "お問い合わせ内容が不正です"
        case .networkError:
            return "ネットワークエラーが発生しました"
        case .unauthorized:
            return "認証が必要です"
        case .serverError:
            return "サーバーエラーが発生しました"
        case .unknown:
            return "不明なエラーが発生しました"
        }
    }
}
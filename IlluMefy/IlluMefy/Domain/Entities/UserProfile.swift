//
//  UserProfile.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// ユーザープロフィールエンティティ
struct UserProfile: Codable, Equatable {
    /// ユーザーID
    let id: String
    
    /// ユーザー名（表示名）
    var displayName: String
    
    /// 自己紹介文
    var bio: String?
    
    /// プロフィール画像URL
    var profileImageUrl: String?
    
    /// メールアドレス
    var email: String
    
    /// 電話番号
    var phoneNumber: String
    
    /// 生年月日
    var birthDate: Date?
    
    /// 性別
    var gender: Gender?
    
    /// アカウント作成日時
    let createdAt: Date
    
    /// 最終更新日時
    var updatedAt: Date
    
    /// アカウント有効状態
    var isActive: Bool
    
    /// 性別の選択肢
    enum Gender: String, Codable, CaseIterable {
        case male
        case female
        case other
        case preferNotToSay
        
        var displayName: String {
            switch self {
            case .male:
                return "男性"
            case .female:
                return "女性"
            case .other:
                return "その他"
            case .preferNotToSay:
                return "回答しない"
            }
        }
    }
}

// MARK: - Validation Extension

extension UserProfile {
    /// バリデーションエラー
    enum ValidationError: LocalizedError {
        case displayNameTooShort
        case displayNameTooLong
        case bioTooLong
        case invalidEmail
        case invalidPhoneNumber
        
        var errorDescription: String? {
            switch self {
            case .displayNameTooShort:
                return "表示名は2文字以上で入力してください"
            case .displayNameTooLong:
                return "表示名は30文字以内で入力してください"
            case .bioTooLong:
                return "自己紹介文は200文字以内で入力してください"
            case .invalidEmail:
                return "メールアドレスの形式が正しくありません"
            case .invalidPhoneNumber:
                return "電話番号の形式が正しくありません"
            }
        }
    }
    
    /// プロフィールのバリデーション
    func validate() throws {
        // 表示名の検証
        if displayName.count < 2 {
            throw ValidationError.displayNameTooShort
        }
        if displayName.count > 30 {
            throw ValidationError.displayNameTooLong
        }
        
        // 自己紹介文の検証
        if let bio = bio, bio.count > 200 {
            throw ValidationError.bioTooLong
        }
        
        // メールアドレスの検証
        if !email.isValidEmail() {
            throw ValidationError.invalidEmail
        }
        
        // 電話番号の検証
        if !phoneNumber.isValidPhoneNumber() {
            throw ValidationError.invalidPhoneNumber
        }
    }
}
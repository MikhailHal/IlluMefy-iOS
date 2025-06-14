//
//  SubmitTagApplicationUseCaseError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// タグ申請送信 UseCase エラー
enum SubmitTagApplicationUseCaseError: LocalizedError {
    case invalidCreatorId
    case invalidTagName
    case tagNameTooLong
    case reasonTooLong
    case creatorNotFound
    case duplicateApplication
    case networkError
    case repositoryError(Error)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidCreatorId:
            return "クリエイターIDが無効です"
        case .invalidTagName:
            return "タグ名が無効です"
        case .tagNameTooLong:
            return "タグ名が長すぎます（50文字以内で入力してください）"
        case .reasonTooLong:
            return "理由が長すぎます（200文字以内で入力してください）"
        case .creatorNotFound:
            return "指定されたクリエイターが見つかりません"
        case .duplicateApplication:
            return "同じタグの申請が既に存在します"
        case .networkError:
            return "ネットワークエラーが発生しました"
        case .repositoryError(let error):
            return error.localizedDescription
        case .unknownError:
            return "予期しないエラーが発生しました"
        }
    }
}
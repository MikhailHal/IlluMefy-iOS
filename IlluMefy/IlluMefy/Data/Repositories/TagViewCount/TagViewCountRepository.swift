//
//  TagViewCountRepository.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation
import FirebaseFirestore

/// タグ閲覧数Repository実装
class TagViewCountRepository: TagViewCountRepositoryProtocol {
    private let db = Firestore.firestore()
    private let collectionName = "tags"
    
    func incrementTagViewCount(_ request: IncrementTagViewCountRequest) async throws {
        do {
            let documentRef = db.collection(collectionName).document(request.tagId)
            try await documentRef.updateData([
                "viewCount": FieldValue.increment(Int64(1)),
                "updatedAt": Timestamp(date: request.incrementedAt)
            ])
            
        } catch {
            throw TagViewCountRepositoryError.incrementError(error.localizedDescription)
        }
    }
}

/// タグ閲覧数Repository エラー
enum TagViewCountRepositoryError: LocalizedError {
    case incrementError(String)
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .incrementError(let message):
            return "閲覧数更新エラー: \(message)"
        case .networkError:
            return "ネットワークエラーが発生しました"
        case .unknownError:
            return "予期しないエラーが発生しました"
        }
    }
}

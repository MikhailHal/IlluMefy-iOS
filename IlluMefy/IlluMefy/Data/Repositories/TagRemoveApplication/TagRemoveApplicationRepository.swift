//
//  TagRemoveApplicationRepository.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation
import FirebaseFirestore

/// タグ削除申請Repository
class TagRemoveApplicationRepository: TagRemoveApplicationRepositoryProtocol {
    private let db = Firestore.firestore()
    private let collectionName = "tagRemoveApplicationList"
    
    func saveTagRemoveApplication(_ request: SaveTagRemoveApplicationRequest) async throws {
        do {
            let documentData: [String: Any] = [
                "name": request.name,
                "userUid": request.userUid,
                "creatorId": request.creatorId,
                "createdAt": Timestamp(date: request.createdAt),
                "state": request.state
            ]
            _ = try await db.collection(collectionName).addDocument(data: documentData)
        } catch {
            throw TagRemoveApplicationRepositoryError.saveError(error.localizedDescription)
        }
    }
}

/// タグ削除申請Repository エラー
enum TagRemoveApplicationRepositoryError: LocalizedError {
    case saveError(String)
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .saveError(let message):
            return "保存エラー: \(message)"
        case .networkError:
            return "ネットワークエラーが発生しました"
        case .unknownError:
            return "予期しないエラーが発生しました"
        }
    }
}
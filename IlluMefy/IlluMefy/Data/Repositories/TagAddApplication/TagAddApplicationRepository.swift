//
//  TagAddApplicationRepository.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation
import FirebaseFirestore

/// タグ追加申請Repository
class TagAddApplicationRepository: TagAddApplicationRepositoryProtocol {
    private let db = Firestore.firestore()
    private let collectionName = "tagAddApplicationList"
    
    func saveTagAddApplication(_ request: SaveTagAddApplicationRequest) async throws {
        do {
            let documentData: [String: Any] = [
                "name": request.name,
                "userUid": request.userUid,
                "createdAt": Timestamp(date: request.createdAt),
                "state": request.state
            ]
            _ = try await db.collection(collectionName).addDocument(data: documentData)
        } catch {
            throw TagAddApplicationRepositoryError.saveError(error.localizedDescription)
        }
    }
}

/// タグ追加申請Repository エラー
enum TagAddApplicationRepositoryError: LocalizedError {
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

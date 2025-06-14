//
//  SubmitTagApplicationUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// タグ申請送信 UseCase 実装
class SubmitTagApplicationUseCase: SubmitTagApplicationUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let tagApplicationRepository: TagApplicationRepositoryProtocol
    private let creatorRepository: CreatorRepositoryProtocol
    
    // MARK: - Initializer
    
    init(
        tagApplicationRepository: TagApplicationRepositoryProtocol,
        creatorRepository: CreatorRepositoryProtocol
    ) {
        self.tagApplicationRepository = tagApplicationRepository
        self.creatorRepository = creatorRepository
    }
    
    // MARK: - UseCase Implementation
    
    func execute(_ request: SubmitTagApplicationUseCaseRequest) async throws -> SubmitTagApplicationUseCaseResponse {
        do {
            // 1. リクエストのバリデーション
            try request.validate()
            
            // 2. クリエイターの存在確認
            do {
                _ = try await creatorRepository.getCreatorById(id: request.creatorId)
            } catch {
                throw SubmitTagApplicationUseCaseError.creatorNotFound
            }
            
            // 3. 重複申請のチェック
            let existingApplications = try await tagApplicationRepository.getApplicationHistory(for: request.creatorId)
            if hasDuplicateApplication(request, in: existingApplications) {
                throw SubmitTagApplicationUseCaseError.duplicateApplication
            }
            
            // 4. タグ申請エンティティの作成
            let application = TagApplication(
                id: "", // Repository で生成される
                creatorId: request.creatorId,
                tagName: request.tagName.trimmingCharacters(in: .whitespacesAndNewlines),
                reason: request.reason?.trimmingCharacters(in: .whitespacesAndNewlines),
                applicationType: request.applicationType,
                status: .pending,
                requestedAt: Date(),
                reviewedAt: nil,
                reviewerId: nil,
                reviewComment: nil
            )
            
            // 5. Repository を通じて申請を保存
            let savedApplication = try await tagApplicationRepository.saveApplication(application)
            
            // 6. レスポンスを作成して返す
            return SubmitTagApplicationUseCaseResponse(application: savedApplication)
            
        } catch let error as SubmitTagApplicationUseCaseError {
            throw error
        } catch let error as TagApplicationRepositoryError {
            throw SubmitTagApplicationUseCaseError.repositoryError(error)
        } catch {
            throw SubmitTagApplicationUseCaseError.unknownError
        }
    }
    
    // MARK: - Private Methods
    
    /// 重複申請をチェック
    private func hasDuplicateApplication(
        _ request: SubmitTagApplicationUseCaseRequest,
        in existingApplications: [TagApplication]
    ) -> Bool {
        return existingApplications.contains { application in
            application.tagName.lowercased() == request.tagName.lowercased() &&
            application.applicationType == request.applicationType &&
            application.status == .pending
        }
    }
}
//
//  SubmitProfileCorrectionUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正依頼送信ユースケース
final class SubmitProfileCorrectionUseCase: SubmitProfileCorrectionUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let profileCorrectionRepository: ProfileCorrectionRepositoryProtocol
    private let creatorRepository: CreatorRepositoryProtocol
    
    // MARK: - Initializer
    
    init(
        profileCorrectionRepository: ProfileCorrectionRepositoryProtocol,
        creatorRepository: CreatorRepositoryProtocol
    ) {
        self.profileCorrectionRepository = profileCorrectionRepository
        self.creatorRepository = creatorRepository
    }
    
    // MARK: - SubmitProfileCorrectionUseCaseProtocol
    
    func execute(_ request: SubmitProfileCorrectionUseCaseRequest) async -> SubmitProfileCorrectionUseCaseResponse {
        do {
            // リクエストのバリデーション
            try request.validate()
            
            // クリエイターの存在確認
            _ = try await creatorRepository.getCreatorById(id: request.creatorId)
            
            // プロフィール修正依頼エンティティを作成
            let correctionRequest = ProfileCorrectionRequest(
                id: UUID().uuidString,
                creatorId: request.creatorId,
                requesterId: request.requesterId,
                correctionItems: request.correctionItems.map { item in
                    ProfileCorrectionRequest.CorrectionItem(
                        type: item.type,
                        currentValue: item.currentValue,
                        suggestedValue: item.suggestedValue
                    )
                },
                reason: request.reason,
                referenceUrl: request.referenceUrl,
                status: .pending,
                requestedAt: Date(),
                reviewedAt: nil,
                reviewerId: nil,
                reviewComment: nil
            )
            
            // 修正依頼を送信
            let submittedRequest = try await profileCorrectionRepository.submitCorrectionRequest(correctionRequest)
            
            return .success(submittedRequest)
            
        } catch let error as SubmitProfileCorrectionUseCaseRequest.ValidationError {
            return .failure(.validationError(error.localizedDescription))
        } catch let error as ProfileCorrectionRepositoryError {
            return .failure(mapRepositoryError(error))
        } catch let error as CreatorRepositoryError {
            return .failure(mapCreatorRepositoryError(error))
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    // MARK: - Private Methods
    
    private func mapRepositoryError(_ error: ProfileCorrectionRepositoryError) -> SubmitProfileCorrectionUseCaseError {
        switch error {
        case .networkError:
            return .networkError
        case .invalidRequest:
            return .validationError(error.localizedDescription)
        case .authenticationError:
            return .authenticationError
        case .authorizationError:
            return .authorizationError
        case .requestNotFound:
            return .unknown(error.localizedDescription)
        case .requestLimitExceeded:
            return .requestLimitExceeded
        case .duplicateRequest:
            return .duplicateRequest
        case .serverError:
            return .serverError
        case .unknown:
            return .unknown(error.localizedDescription)
        }
    }
    
    private func mapCreatorRepositoryError(_ error: CreatorRepositoryError) -> SubmitProfileCorrectionUseCaseError {
        switch error {
        case .networkError:
            return .networkError
        case .creatorNotFound, .notFound:
            return .creatorNotFound
        case .decodingError:
            return .validationError(error.localizedDescription)
        case .unauthorized:
            return .authenticationError
        case .serverError:
            return .serverError
        case .unknown:
            return .unknown(error.localizedDescription)
        }
    }
}

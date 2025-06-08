//
//  GetPopularCreatorsUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

/**
 人気クリエイター取得ユースケース
 
 アプリ内で人気の高いクリエイターを取得します。
 ホーム画面のおすすめ表示などで使用されます。
 */
final class GetPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol {
    
    private let creatorRepository: CreatorRepositoryProtocol
    
    init(creatorRepository: CreatorRepositoryProtocol) {
        self.creatorRepository = creatorRepository
    }
    
    func execute(request: GetPopularCreatorsUseCaseRequest) async throws -> GetPopularCreatorsUseCaseResponse {
        do {
            let creators = try await creatorRepository.getPopularCreators(limit: request.limit)
            
            // ビジネスロジック: アクティブなクリエイターのみフィルタリング
            let activeCreators = creators.filter { $0.isActive }
            
            return GetPopularCreatorsUseCaseResponse(
                creators: activeCreators,
                hasMore: activeCreators.count == request.limit
            )
        } catch let error as CreatorRepositoryError {
            throw GetPopularCreatorsUseCaseError.repositoryError(error)
        } catch {
            throw GetPopularCreatorsUseCaseError.unknown(error)
        }
    }
}

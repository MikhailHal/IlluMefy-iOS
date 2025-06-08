//
//  GetPopularCreatorsUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

protocol GetPopularCreatorsUseCaseProtocol {
    func execute(request: GetPopularCreatorsUseCaseRequest) async throws -> GetPopularCreatorsUseCaseResponse
}

//
//  GetNewestCreatorsUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/12.
//

import Foundation

protocol GetNewestCreatorsUseCaseProtocol {
    func execute(request: GetNewestCreatorsUseCaseRequest) async throws -> GetNewestCreatorsUseCaseResponse
}
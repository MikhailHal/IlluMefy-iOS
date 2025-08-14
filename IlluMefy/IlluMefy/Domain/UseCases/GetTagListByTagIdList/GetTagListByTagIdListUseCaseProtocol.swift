//
//  GetTagListByTagIdListUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/14.
//

import Foundation

protocol GetTagListByTagIdListUseCaseProtocol {
    func execute(request: GetTagListByTagIdListUseCaseRequest) async throws -> GetTagListByTagIdListUseCaseResponse
}
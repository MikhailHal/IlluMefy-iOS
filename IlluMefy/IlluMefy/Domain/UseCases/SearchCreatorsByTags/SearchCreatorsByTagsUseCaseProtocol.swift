//
//  SearchCreatorsByTagsUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

protocol SearchCreatorsByTagsUseCaseProtocol {
    func execute(request: SearchCreatorsByTagsUseCaseRequest) async throws -> SearchCreatorsByTagsUseCaseResponse
}

//
//  GetFavoriteCreatorsUseCaseSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/27.
//

import Foundation
import Quick
import Nimble
@testable import IlluMefy

class GetFavoriteCreatorsUseCaseSpec: QuickSpec {
    override class func spec() {
        describe("GetFavoriteCreatorsUseCase") {
            var sut: GetFavoriteCreatorsUseCase!
            var mockFavoriteRepository: MockFavoriteRepository!
            var mockCreatorRepository: TestMockCreatorRepository!
            
            beforeEach {
                mockFavoriteRepository = MockFavoriteRepository()
                mockCreatorRepository = TestMockCreatorRepository()
                sut = GetFavoriteCreatorsUseCase(
                    favoriteRepository: mockFavoriteRepository,
                    creatorRepository: mockCreatorRepository
                )
            }
            
            describe("execute") {
                context("when favorites exist and all creators found") {
                    beforeEach {
                        mockFavoriteRepository.mockFavoriteIds = ["creator_001", "creator_003", "creator_005"]
                    }
                    
                    it("returns favorite creators in order") {
                        waitUntil { done in
                            Task {
                                do {
                                    let result = try await sut.execute()
                                    expect(result.count).to(equal(3))
                                    expect(result[0].id).to(equal("creator_001"))
                                    expect(result[1].id).to(equal("creator_003"))
                                    expect(result[2].id).to(equal("creator_005"))
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("when no favorites exist") {
                    beforeEach {
                        mockFavoriteRepository.mockFavoriteIds = []
                    }
                    
                    it("returns empty array") {
                        waitUntil { done in
                            Task {
                                do {
                                    let result = try await sut.execute()
                                    expect(result).to(beEmpty())
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("when some creators not found") {
                    beforeEach {
                        mockFavoriteRepository.mockFavoriteIds = ["creator_001", "creator_999", "creator_003"]
                        mockCreatorRepository.shouldThrowNotFoundForId = "creator_999"
                    }
                    
                    it("returns only existing creators") {
                        waitUntil { done in
                            Task {
                                do {
                                    let result = try await sut.execute()
                                    expect(result.count).to(equal(2))
                                    expect(result.map { $0.id }).to(equal(["creator_001", "creator_003"]))
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("when repository throws error") {
                    beforeEach {
                        mockFavoriteRepository.shouldThrowError = true
                    }
                    
                    it("propagates the error") {
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await sut.execute()
                                    fail("Should throw error")
                                    done()
                                } catch {
                                    expect(error).toNot(beNil())
                                    done()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Mock Classes

class TestMockCreatorRepository: CreatorRepositoryProtocol {
    var shouldThrowNotFoundForId: String?
    private let baseRepository = MockCreatorRepository()
    
    func getAllCreators() async throws -> [Creator] {
        return try await baseRepository.getAllCreators()
    }
    
    func getCreatorsUpdatedAfter(date: Date) async throws -> [Creator] {
        return try await baseRepository.getCreatorsUpdatedAfter(date: date)
    }
    
    func searchCreatorsByTags(tagIds: [String]) async throws -> [Creator] {
        return try await baseRepository.searchCreatorsByTags(tagIds: tagIds)
    }
    
    func getPopularCreators(limit: Int) async throws -> [Creator] {
        return try await baseRepository.getPopularCreators(limit: limit)
    }
    
    func getCreatorById(id: String) async throws -> Creator {
        if let throwId = shouldThrowNotFoundForId, throwId == id {
            throw CreatorRepositoryError.creatorNotFound
        }
        return try await baseRepository.getCreatorById(id: id)
    }
    
    func getSimilarCreators(creatorId: String, limit: Int) async throws -> [Creator] {
        return try await baseRepository.getSimilarCreators(creatorId: creatorId, limit: limit)
    }
    
    func searchByName(query: String, sortOrder: CreatorSortOrder, offset: Int, limit: Int) async throws -> CreatorSearchResult {
        return try await baseRepository.searchByName(query: query, sortOrder: sortOrder, offset: offset, limit: limit)
    }
    
    func searchByTags(tagIds: [String], searchMode: TagSearchMode, sortOrder: CreatorSortOrder, offset: Int, limit: Int) async throws -> CreatorSearchResult {
        return try await baseRepository.searchByTags(tagIds: tagIds, searchMode: searchMode, sortOrder: sortOrder, offset: offset, limit: limit)
    }
}

class MockFavoriteRepository: FavoriteRepositoryProtocol {
    var mockFavoriteIds: [String] = []
    var shouldThrowError = false
    
    func getFavoriteCreatorIds() async throws -> [String] {
        if shouldThrowError {
            throw NSError(domain: "test", code: 1, userInfo: nil)
        }
        return mockFavoriteIds
    }
    
    func addFavoriteCreator(creatorId: String) async throws {
        if shouldThrowError {
            throw NSError(domain: "test", code: 1, userInfo: nil)
        }
        if !mockFavoriteIds.contains(creatorId) {
            mockFavoriteIds.insert(creatorId, at: 0)
        }
    }
    
    func removeFavoriteCreator(creatorId: String) async throws {
        if shouldThrowError {
            throw NSError(domain: "test", code: 1, userInfo: nil)
        }
        mockFavoriteIds.removeAll { $0 == creatorId }
    }
    
    func isFavorite(creatorId: String) async throws -> Bool {
        if shouldThrowError {
            throw NSError(domain: "test", code: 1, userInfo: nil)
        }
        return mockFavoriteIds.contains(creatorId)
    }
}
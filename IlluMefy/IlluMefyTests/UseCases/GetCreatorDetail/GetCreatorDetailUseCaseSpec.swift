//
//  GetCreatorDetailUseCaseSpec.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/14.
//

import Quick
import Nimble
@testable import IlluMefy

final class GetCreatorDetailUseCaseSpec: QuickSpec, @unchecked Sendable {
    override class func spec() {
        var mockRepository: MockCreatorRepository!
        var useCase: GetCreatorDetailUseCase!
        var request: GetCreatorDetailUseCaseRequest!
        
        describe("GetCreatorDetailUseCase") {
            beforeEach {
                mockRepository = MockCreatorRepository()
                useCase = GetCreatorDetailUseCase(creatorRepository: mockRepository)
            }
            
            context("正常系") {
                let validCreatorId = "creator_001"
                let expectedCreatorName = "ゲーム実況者A"
                
                beforeEach {
                    request = GetCreatorDetailUseCaseRequest(
                        creatorId: validCreatorId,
                        similarCreatorsLimit: 3
                    )
                }
                
                it("should return creator detail and similar creators") {
                    waitUntil { done in
                        Task {
                            let response = try await useCase.execute(request: request)
                            
                            expect(response.creator.id).to(equal(validCreatorId))
                            expect(response.creator.name).to(equal(expectedCreatorName))
                            expect(response.similarCreators.count).to(beLessThanOrEqualTo(3))
                            
                            // 自分自身は除外されているか確認
                            let containsSelf = response.similarCreators.contains { $0.id == validCreatorId }
                            expect(containsSelf).to(beFalse())
                            
                            done()
                        }
                    }
                }
                
                it("should respect similar creators limit") {
                    waitUntil { done in
                        Task {
                            request = GetCreatorDetailUseCaseRequest(
                                creatorId: validCreatorId,
                                similarCreatorsLimit: 2
                            )
                            
                            let response = try await useCase.execute(request: request)
                            expect(response.similarCreators.count).to(beLessThanOrEqualTo(2))
                            done()
                        }
                    }
                }
            }
            
            context("異常系 - 存在しないクリエイター") {
                beforeEach {
                    request = GetCreatorDetailUseCaseRequest(
                        creatorId: "non_existent_creator",
                        similarCreatorsLimit: 3
                    )
                }
                
                it("should throw creatorNotFound error") {
                    waitUntil { done in
                        Task {
                            do {
                                _ = try await useCase.execute(request: request)
                                fail("Expected error but succeeded")
                            } catch let error as GetCreatorDetailUseCaseError {
                                expect(error).to(equal(.creatorNotFound))
                            } catch {
                                fail("Unexpected error type: \(error)")
                            }
                            done()
                        }
                    }
                }
            }
            
            context("異常系 - 不正なリクエスト") {
                it("should throw invalidRequest error for empty creator ID") {
                    waitUntil { done in
                        Task {
                            request = GetCreatorDetailUseCaseRequest(
                                creatorId: "",
                                similarCreatorsLimit: 3
                            )
                            
                            do {
                                _ = try await useCase.execute(request: request)
                                fail("Expected error but succeeded")
                            } catch let error as GetCreatorDetailUseCaseError {
                                expect(error).to(equal(.invalidRequest))
                            } catch {
                                fail("Unexpected error type: \(error)")
                            }
                            done()
                        }
                    }
                }
                
                it("should throw invalidRequest error for negative similar creators limit") {
                    waitUntil { done in
                        Task {
                            request = GetCreatorDetailUseCaseRequest(
                                creatorId: "creator_001",
                                similarCreatorsLimit: -1
                            )
                            
                            do {
                                _ = try await useCase.execute(request: request)
                                fail("Expected error but succeeded")
                            } catch let error as GetCreatorDetailUseCaseError {
                                expect(error).to(equal(.invalidRequest))
                            } catch {
                                fail("Unexpected error type: \(error)")
                            }
                            done()
                        }
                    }
                }
                
                it("should throw invalidRequest error for zero similar creators limit") {
                    waitUntil { done in
                        Task {
                            request = GetCreatorDetailUseCaseRequest(
                                creatorId: "creator_001",
                                similarCreatorsLimit: 0
                            )
                            
                            do {
                                _ = try await useCase.execute(request: request)
                                fail("Expected error but succeeded")
                            } catch let error as GetCreatorDetailUseCaseError {
                                expect(error).to(equal(.invalidRequest))
                            } catch {
                                fail("Unexpected error type: \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
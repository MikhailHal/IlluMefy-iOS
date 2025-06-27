//
//  FavoriteRepositorySpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/27.
//

import Foundation
import Quick
import Nimble
@testable import IlluMefy

class FavoriteRepositorySpec: QuickSpec {
    override class func spec() {
        describe("FavoriteRepository") {
            var sut: FavoriteRepository!
            var userDefaults: UserDefaults!
            let testKey = "TestFavoriteCreatorIds"
            
            beforeEach {
                userDefaults = UserDefaults(suiteName: "com.illumefy.test")!
                userDefaults.removePersistentDomain(forName: "com.illumefy.test")
                sut = FavoriteRepository(userDefaults: userDefaults, favoritesKey: testKey)
            }
            
            afterEach {
                userDefaults.removePersistentDomain(forName: "com.illumefy.test")
            }
            
            describe("getFavoriteCreatorIds") {
                context("when no favorites exist") {
                    it("returns mock data on first access") {
                        var result: [String] = []
                        
                        waitUntil { done in
                            Task {
                                do {
                                    result = try await sut.getFavoriteCreatorIds()
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                        
                        expect(result).to(equal(["creator_001", "creator_004", "creator_007"]))
                    }
                }
                
                context("when favorites already exist") {
                    beforeEach {
                        userDefaults.set(["creator_002", "creator_005"], forKey: testKey)
                    }
                    
                    it("returns stored favorites") {
                        var result: [String] = []
                        
                        waitUntil { done in
                            Task {
                                do {
                                    result = try await sut.getFavoriteCreatorIds()
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                        
                        expect(result).to(equal(["creator_002", "creator_005"]))
                    }
                }
            }
            
            describe("addFavoriteCreator") {
                context("when adding a new favorite") {
                    beforeEach {
                        userDefaults.set(["creator_001"], forKey: testKey)
                    }
                    
                    it("adds creator to favorites") {
                        waitUntil { done in
                            Task {
                                do {
                                    try await sut.addFavoriteCreator(creatorId: "creator_002")
                                    let favorites = try await sut.getFavoriteCreatorIds()
                                    expect(favorites).to(contain("creator_002"))
                                    expect(favorites.first).to(equal("creator_002")) // 新しいものが先頭
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("when adding duplicate favorite") {
                    beforeEach {
                        userDefaults.set(["creator_001", "creator_002"], forKey: testKey)
                    }
                    
                    it("does not add duplicate") {
                        waitUntil { done in
                            Task {
                                do {
                                    try await sut.addFavoriteCreator(creatorId: "creator_001")
                                    let favorites = try await sut.getFavoriteCreatorIds()
                                    expect(favorites.filter { $0 == "creator_001" }.count).to(equal(1))
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
            }
            
            describe("removeFavoriteCreator") {
                context("when removing existing favorite") {
                    beforeEach {
                        userDefaults.set(["creator_001", "creator_002", "creator_003"], forKey: testKey)
                    }
                    
                    it("removes creator from favorites") {
                        waitUntil { done in
                            Task {
                                do {
                                    try await sut.removeFavoriteCreator(creatorId: "creator_002")
                                    let favorites = try await sut.getFavoriteCreatorIds()
                                    expect(favorites).toNot(contain("creator_002"))
                                    expect(favorites.count).to(equal(2))
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("when removing non-existent favorite") {
                    beforeEach {
                        userDefaults.set(["creator_001"], forKey: testKey)
                    }
                    
                    it("does nothing") {
                        waitUntil { done in
                            Task {
                                do {
                                    try await sut.removeFavoriteCreator(creatorId: "creator_999")
                                    let favorites = try await sut.getFavoriteCreatorIds()
                                    expect(favorites).to(equal(["creator_001"]))
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
            }
            
            describe("isFavorite") {
                beforeEach {
                    userDefaults.set(["creator_001", "creator_002"], forKey: testKey)
                }
                
                context("when creator is favorite") {
                    it("returns true") {
                        waitUntil { done in
                            Task {
                                do {
                                    let result = try await sut.isFavorite(creatorId: "creator_001")
                                    expect(result).to(beTrue())
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("when creator is not favorite") {
                    it("returns false") {
                        waitUntil { done in
                            Task {
                                do {
                                    let result = try await sut.isFavorite(creatorId: "creator_999")
                                    expect(result).to(beFalse())
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
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
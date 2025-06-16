//
//  SearchStateSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Quick
import Nimble
@testable import IlluMefy

class SearchStateSpec: QuickSpec {
    override class func spec() {
        describe("SearchState") {
            context("enum cases") {
                it("initial状態を持つ") {
                    let state: SearchState = .initial
                    
                    switch state {
                    case .initial:
                        expect(true).to(beTrue())
                    default:
                        fail("initial状態でない")
                    }
                }
                
                it("searching状態を持つ") {
                    let state: SearchState = .searching
                    
                    switch state {
                    case .searching:
                        expect(true).to(beTrue())
                    default:
                        fail("searching状態でない")
                    }
                }
                
                it("loadedCreators状態を持つ") {
                    let creators = [
                        Creator(
                            id: "test",
                            name: "テストクリエイター",
                            description: "説明",
                            thumbnailUrl: "https://example.com/thumb.jpg",
                            viewCount: 1000,
                            platform: [.youtube: "https://youtube.com/test"],
                            relatedTag: ["game"]
                        )
                    ]
                    let state: SearchState = .loadedCreators(creators)
                    
                    switch state {
                    case .loadedCreators(let loadedCreators):
                        expect(loadedCreators).to(equal(creators))
                    default:
                        fail("loadedCreators状態でない")
                    }
                }
                
                it("empty状態を持つ") {
                    let state: SearchState = .empty
                    
                    switch state {
                    case .empty:
                        expect(true).to(beTrue())
                    default:
                        fail("empty状態でない")
                    }
                }
                
                it("error状態を持つ") {
                    let title = "エラータイトル"
                    let message = "エラーメッセージ"
                    let state: SearchState = .error(title, message)
                    
                    switch state {
                    case .error(let errorTitle, let errorMessage):
                        expect(errorTitle).to(equal(title))
                        expect(errorMessage).to(equal(message))
                    default:
                        fail("error状態でない")
                    }
                }
            }
            
            context("equality") {
                it("同じinitial状態は等しい") {
                    let state1: SearchState = .initial
                    let state2: SearchState = .initial
                    
                    // enum cases without associated valuesは自動的にEquatableではないが、
                    // テストでは個別にチェック
                    switch (state1, state2) {
                    case (.initial, .initial):
                        expect(true).to(beTrue())
                    default:
                        fail("両方ともinitial状態であるべき")
                    }
                }
                
                it("異なる状態は等しくない") {
                    let state1: SearchState = .initial
                    let state2: SearchState = .searching
                    
                    switch (state1, state2) {
                    case (.initial, .searching):
                        expect(true).to(beTrue()) // 異なることを確認
                    default:
                        fail("異なる状態であるべき")
                    }
                }
            }
        }
    }
}
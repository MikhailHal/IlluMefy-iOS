//
//  ContactSupportTests.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/27.
//

import Nimble
import Quick
import Foundation
@testable import IlluMefy

class ContactSupportTests: QuickSpec {
    override class func spec() {
        describe("ContactSupport Entity") {
            context("初期化") {
                it("正しく初期化される") {
                    let date = Date()
                    let support = ContactSupport(
                        id: "test-id",
                        type: .bugReport,
                        content: "テストコンテンツ",
                        userId: "user-123",
                        submittedAt: date,
                        status: .pending
                    )
                    
                    expect(support.id).to(equal("test-id"))
                    expect(support.type).to(equal(.bugReport))
                    expect(support.content).to(equal("テストコンテンツ"))
                    expect(support.userId).to(equal("user-123"))
                    expect(support.submittedAt).to(equal(date))
                    expect(support.status).to(equal(.pending))
                }
            }
            
            context("ContactSupportType") {
                it("すべてのタイプが正しい表示名を持つ") {
                    expect(ContactSupportType.bugReport.displayName).to(equal("不具合報告"))
                    expect(ContactSupportType.featureRequest.displayName).to(equal("機能追加依頼"))
                    expect(ContactSupportType.other.displayName).to(equal("その他"))
                }
                
                it("すべてのタイプが正しいアイコンを持つ") {
                    expect(ContactSupportType.bugReport.icon).to(equal("exclamationmark.triangle"))
                    expect(ContactSupportType.featureRequest.icon).to(equal("lightbulb"))
                    expect(ContactSupportType.other.icon).to(equal("questionmark.circle"))
                }
                
                it("すべてのタイプが正しいプレースホルダーを持つ") {
                    expect(ContactSupportType.bugReport.placeholder).to(contain("不具合"))
                    expect(ContactSupportType.featureRequest.placeholder).to(contain("機能"))
                    expect(ContactSupportType.other.placeholder).to(contain("詳細"))
                }
            }
            
            context("ContactSupportStatus") {
                it("すべてのステータスが正しい表示名を持つ") {
                    expect(ContactSupportStatus.pending.displayName).to(equal("受付中"))
                    expect(ContactSupportStatus.inProgress.displayName).to(equal("対応中"))
                    expect(ContactSupportStatus.resolved.displayName).to(equal("解決済み"))
                }
            }
        }
        
        describe("ContactSupportError") {
            it("エラーが正しいローカライズされた説明を持つ") {
                expect(ContactSupportError.invalidInput.localizedDescription).to(equal("入力内容が無効です"))
                expect(ContactSupportError.networkError.localizedDescription).to(equal("ネットワークエラーが発生しました"))
                expect(ContactSupportError.unauthorized.localizedDescription).to(equal("認証が必要です"))
                expect(ContactSupportError.serverError.localizedDescription).to(equal("サーバーエラーが発生しました"))
                expect(ContactSupportError.unknown.localizedDescription).to(equal("不明なエラーが発生しました"))
            }
        }
        
        describe("SubmitContactSupportUseCase") {
            var useCase: SubmitContactSupportUseCase!
            var mockRepository: MockContactSupportRepository!
            
            beforeEach {
                mockRepository = MockContactSupportRepository()
                useCase = SubmitContactSupportUseCase(repository: mockRepository)
            }
            
            context("正常なケース") {
                it("お問い合わせが正しく送信される") {
                    waitUntil { done in
                        Task {
                            do {
                                let result = try await useCase.execute(
                                    type: .bugReport,
                                    content: "テストコンテンツ",
                                    userId: "user-123"
                                )
                                
                                expect(result.type).to(equal(.bugReport))
                                expect(result.content).to(equal("テストコンテンツ"))
                                expect(result.userId).to(equal("user-123"))
                                expect(result.status).to(equal(.pending))
                                expect(mockRepository.submittedSupport).toNot(beNil())
                                done()
                            } catch {
                                fail("エラーが発生しました: \(error)")
                                done()
                            }
                        }
                    }
                }
            }
            
            context("エラーケース") {
                it("空のユーザーIDでunauthorizedエラーが発生する") {
                    waitUntil { done in
                        Task {
                            do {
                                let _ = try await useCase.execute(
                                    type: .bugReport,
                                    content: "テストコンテンツ",
                                    userId: ""
                                )
                                fail("エラーが発生するべきです")
                                done()
                            } catch let error as ContactSupportError {
                                expect(error).to(equal(.unauthorized))
                                done()
                            } catch {
                                fail("予期しないエラー: \(error)")
                                done()
                            }
                        }
                    }
                }
                
                it("空のコンテンツでinvalidInputエラーが発生する") {
                    waitUntil { done in
                        Task {
                            do {
                                let _ = try await useCase.execute(
                                    type: .bugReport,
                                    content: "",
                                    userId: "user-123"
                                )
                                fail("エラーが発生するべきです")
                                done()
                            } catch let error as ContactSupportError {
                                expect(error).to(equal(.invalidInput))
                                done()
                            } catch {
                                fail("予期しないエラー: \(error)")
                                done()
                            }
                        }
                    }
                }
                
                it("500文字を超えるコンテンツでinvalidInputエラーが発生する") {
                    let longContent = String(repeating: "a", count: 501)
                    waitUntil { done in
                        Task {
                            do {
                                let _ = try await useCase.execute(
                                    type: .bugReport,
                                    content: longContent,
                                    userId: "user-123"
                                )
                                fail("エラーが発生するべきです")
                                done()
                            } catch let error as ContactSupportError {
                                expect(error).to(equal(.invalidInput))
                                done()
                            } catch {
                                fail("予期しないエラー: \(error)")
                                done()
                            }
                        }
                    }
                }
            }
        }
        
        describe("GetContactSupportHistoryUseCase") {
            var useCase: GetContactSupportHistoryUseCase!
            var mockRepository: MockContactSupportRepository!
            
            beforeEach {
                mockRepository = MockContactSupportRepository()
                useCase = GetContactSupportHistoryUseCase(repository: mockRepository)
            }
            
            context("正常なケース") {
                it("履歴が正しく取得される") {
                    waitUntil { done in
                        Task {
                            do {
                                let history = try await useCase.execute(userId: "user-123")
                                
                                expect(history.count).to(equal(2))
                                // 新しい順にソートされているかチェック
                                expect(history[0].submittedAt).to(beGreaterThan(history[1].submittedAt))
                                done()
                            } catch {
                                fail("エラーが発生しました: \(error)")
                                done()
                            }
                        }
                    }
                }
            }
            
            context("エラーケース") {
                it("空のユーザーIDでunauthorizedエラーが発生する") {
                    waitUntil { done in
                        Task {
                            do {
                                let _ = try await useCase.execute(userId: "")
                                fail("エラーが発生するべきです")
                                done()
                            } catch let error as ContactSupportError {
                                expect(error).to(equal(.unauthorized))
                                done()
                            } catch {
                                fail("予期しないエラー: \(error)")
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}

private class MockContactSupportRepository: ContactSupportRepositoryProtocol {
    var submittedSupport: ContactSupport?
    
    func submitContactSupport(_ request: ContactSupportRequest) async throws -> ContactSupport {
        let support = ContactSupport(
            id: UUID().uuidString,
            type: request.type,
            content: request.content,
            submittedAt: Date(),
            status: .pending,
            userId: request.userId
        )
        submittedSupport = support
        return support
    }
    
    func getContactSupportHistory(userId: String) async throws -> [ContactSupport] {
        return [
            ContactSupport(
                id: "1",
                type: .bugReport,
                content: "テスト1",
                submittedAt: Date().addingTimeInterval(-3600),
                status: .pending,
                userId: userId
            ),
            ContactSupport(
                id: "2",
                type: .featureRequest,
                content: "テスト2",
                submittedAt: Date().addingTimeInterval(-7200),
                status: .resolved,
                userId: userId
            )
        ]
    }
    
    func getContactSupport(id: String) async throws -> ContactSupport {
        return ContactSupport(
            id: id,
            type: .bugReport,
            content: "テストコンテンツ",
            submittedAt: Date(),
            status: .pending,
            userId: "user-123"
        )
    }
}
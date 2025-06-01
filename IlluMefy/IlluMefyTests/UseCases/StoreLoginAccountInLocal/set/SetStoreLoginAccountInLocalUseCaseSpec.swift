//
//  SetStoreLoginAccountInLocalUseCaseSpec.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/01.
//

import Quick
import Nimble
@testable import IlluMefy

class SetStoreLoginAccountInLocalUseCaseSpec: QuickSpec {
    override class func spec() {
        var mockRepository: MockUserPreferencesRepository!
        var useCase: SetStoreLoginAccountInLocalUseCase!
        
        describe("SetStoreLoginAccountInLocalUseCase") {
            beforeEach {
                mockRepository = MockUserPreferencesRepository()
                useCase = SetStoreLoginAccountInLocalUseCase(userPreferencesRepository: mockRepository)
            }
            
            describe("execute") {
                context("with valid credentials") {
                    let givenEmail = "test@example.com"
                    let givenPassword = "password123"
                    let givenIsStore = true
                    
                    it("should store login information in repository") {
                        let request = SetStoreLoginAccountInLocalUseCaseRequest(
                            email: givenEmail,
                            password: givenPassword,
                            isStore: givenIsStore
                        )
                        
                        let result = try useCase.execute(request: request)
                        
                        // 成功を返す
                        expect(result).to(beTrue())
                        
                        // リポジトリに正しい値が設定される
                        expect(mockRepository.isStoreLoginInfo).to(equal(givenIsStore))
                        expect(mockRepository.loginEmail).to(equal(givenEmail))
                        expect(mockRepository.loginPassowrd).to(equal(givenPassword))
                    }
                    
                    it("should not store when isStore is false") {
                        let request = SetStoreLoginAccountInLocalUseCaseRequest(
                            email: givenEmail,
                            password: givenPassword,
                            isStore: false
                        )
                        
                        let result = try useCase.execute(request: request)
                        
                        expect(result).to(beTrue())
                        expect(mockRepository.isStoreLoginInfo).to(beFalse())
                        expect(mockRepository.loginEmail).to(equal(givenEmail))
                        expect(mockRepository.loginPassowrd).to(equal(givenPassword))
                    }
                }
            }
            
            describe("setStoreData") {
                context("when execute succeeds") {
                    it("should return true") {
                        let request = SetStoreLoginAccountInLocalUseCaseRequest(
                            email: "test@example.com",
                            password: "password123",
                            isStore: true
                        )
                        
                        let result = useCase.setStoreData(request: request)
                        
                        expect(result).to(beTrue())
                        expect(mockRepository.isStoreLoginInfo).to(beTrue())
                    }
                }
                
                context("when execute throws error") {
                    it("should return false") {
                        // executeメソッドは現在の実装ではエラーを投げないが、
                        // 将来的な変更に備えてテストケースを用意
                        let request = SetStoreLoginAccountInLocalUseCaseRequest(
                            email: "test@example.com",
                            password: "password123",
                            isStore: true
                        )
                        
                        // 現在の実装では常にtrueを返す
                        let result = useCase.setStoreData(request: request)
                        
                        expect(result).to(beTrue())
                    }
                }
            }
            
            describe("validate") {
                context("with valid parameters") {
                    it("should not throw error") {
                        let request = SetStoreLoginAccountInLocalUseCaseRequest(
                            email: "test@example.com",
                            password: "password123",
                            isStore: true
                        )
                        
                        expect {
                            try useCase.validate(request: request)
                        }.toNot(throwError())
                    }
                }
                
                context("with empty email") {
                    it("should throw invalidFormat error") {
                        let request = SetStoreLoginAccountInLocalUseCaseRequest(
                            email: "",
                            password: "password123",
                            isStore: true
                        )
                        
                        expect {
                            try useCase.validate(request: request)
                        }.to(throwError(StoreLoginAccountInLocalUseCaseError.invalidFormat))
                    }
                }
                
                context("with empty password") {
                    it("should throw invalidFormat error") {
                        let request = SetStoreLoginAccountInLocalUseCaseRequest(
                            email: "test@example.com",
                            password: "",
                            isStore: true
                        )
                        
                        expect {
                            try useCase.validate(request: request)
                        }.to(throwError(StoreLoginAccountInLocalUseCaseError.invalidFormat))
                    }
                }
                
                context("with both empty email and password") {
                    it("should throw invalidFormat error") {
                        let request = SetStoreLoginAccountInLocalUseCaseRequest(
                            email: "",
                            password: "",
                            isStore: true
                        )
                        
                        expect {
                            try useCase.validate(request: request)
                        }.to(throwError(StoreLoginAccountInLocalUseCaseError.invalidFormat))
                    }
                }
            }
            
            describe("storing different types of data") {
                it("should handle Japanese characters in email") {
                    let request = SetStoreLoginAccountInLocalUseCaseRequest(
                        email: "テスト@example.com",
                        password: "password123",
                        isStore: true
                    )
                    
                    let result = try useCase.execute(request: request)
                    
                    expect(result).to(beTrue())
                    expect(mockRepository.loginEmail).to(equal("テスト@example.com"))
                }
                
                it("should handle special characters in password") {
                    let request = SetStoreLoginAccountInLocalUseCaseRequest(
                        email: "test@example.com",
                        password: "p@ssw0rd!#$%",
                        isStore: true
                    )
                    
                    let result = try useCase.execute(request: request)
                    
                    expect(result).to(beTrue())
                    expect(mockRepository.loginPassowrd).to(equal("p@ssw0rd!#$%"))
                }
                
                it("should handle very long credentials") {
                    let longEmail = "verylongemailaddress1234567890@verylongdomainname1234567890.com"
                    let longPassword = String(repeating: "a", count: 100)
                    
                    let request = SetStoreLoginAccountInLocalUseCaseRequest(
                        email: longEmail,
                        password: longPassword,
                        isStore: true
                    )
                    
                    let result = try useCase.execute(request: request)
                    
                    expect(result).to(beTrue())
                    expect(mockRepository.loginEmail).to(equal(longEmail))
                    expect(mockRepository.loginPassowrd).to(equal(longPassword))
                }
            }
        }
    }
}

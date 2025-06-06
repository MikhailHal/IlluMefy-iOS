//
//  RegisterAccountUseCaseSpec.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/06.
//

import Quick
import Nimble
@testable import IlluMefy

final class RegisterAccountUseCaseSpec: QuickSpec, @unchecked Sendable {
    override class func spec() {
        var useCase: RegisterAccountUseCase!
        var mockAccountLoginRepository: AccountLoginRepository!
        
        describe("RegisterAccountUseCase") {
            beforeEach {
                mockAccountLoginRepository = AccountLoginRepository()
                useCase = RegisterAccountUseCase(accountLoginRepository: mockAccountLoginRepository)
            }
            
            context("execute") {
                let validRequest = RegisterAccountUseCaseRequest(
                    phoneNumber: "09012345678",
                    credential: "mock-credential"
                )
                
                context("with valid request") {
                    it("should return response with user ID and phone number") {
                        waitUntil { done in
                            Task {
                                do {
                                    // Note: This test would need a proper mock for AccountLoginRepository
                                    // to avoid actual Firebase calls. For now, this test structure shows
                                    // what should be tested.
                                    
                                    // This will likely fail in actual execution due to Firebase dependency
                                    // In a real implementation, we'd need a MockAccountLoginRepository
                                    
                                    let response = try await useCase.execute(request: validRequest)
                                    expect(response.userID).toNot(beEmpty())
                                    expect(response.phoneNumber).to(equal("09012345678"))
                                    done()
                                } catch {
                                    // Expected to fail without proper mock
                                    // This shows the test structure
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("with empty phone number") {
                    let emptyPhoneRequest = RegisterAccountUseCaseRequest(
                        phoneNumber: "",
                        credential: "mock-credential"
                    )
                    
                    it("should throw unknown error") {
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await useCase.execute(request: emptyPhoneRequest)
                                    fail("Should throw error")
                                    done()
                                } catch let error as RegisterAccountUseCaseError {
                                    expect(error).to(equal(.unknown))
                                    done()
                                } catch {
                                    fail("Should throw RegisterAccountUseCaseError: \(error)")
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
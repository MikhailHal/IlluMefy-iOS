//
//  VerifyPhoneAuthCodeUseCaseSpec.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/06.
//

import Quick
import Nimble
@testable import IlluMefy

final class VerifyPhoneAuthCodeUseCaseSpec: QuickSpec, @unchecked Sendable {
    override class func spec() {
        var useCase: VerifyPhoneAuthCodeUseCase!
        var mockPhoneAuthRepository: MockPhoneAuthRepository!
        
        describe("VerifyPhoneAuthCodeUseCase") {
            beforeEach {
                mockPhoneAuthRepository = MockPhoneAuthRepository()
                useCase = VerifyPhoneAuthCodeUseCase(phoneAuthRepository: mockPhoneAuthRepository)
            }
            
            context("execute") {
                let validRequest = VerifyPhoneAuthCodeUseCaseRequest(
                    verificationID: "test-verification-id",
                    verificationCode: "123456"
                )
                
                context("with valid request") {
                    it("should return credential when repository succeeds") {
                        waitUntil { done in
                            Task {
                                do {
                                    let response = try await useCase.execute(request: validRequest)
                                    expect(response.credential).toNot(beNil())
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                    
                    it("should call repository with correct parameters") {
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await useCase.execute(request: validRequest)
                                    // MockPhoneAuthRepositoryの実装確認が必要
                                    done()
                                } catch {
                                    fail("Should not throw error: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("with invalid verification code") {
                    let invalidCodeRequest = VerifyPhoneAuthCodeUseCaseRequest(
                        verificationID: "test-verification-id",
                        verificationCode: "12345" // 5桁
                    )
                    
                    it("should throw invalidVerificationCode error") {
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await useCase.execute(request: invalidCodeRequest)
                                    fail("Should throw error")
                                    done()
                                } catch let error as VerifyPhoneAuthCodeUseCaseError {
                                    expect(error).to(equal(.invalidVerificationCode))
                                    done()
                                } catch {
                                    fail("Should throw VerifyPhoneAuthCodeUseCaseError: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("with non-numeric verification code") {
                    let nonNumericRequest = VerifyPhoneAuthCodeUseCaseRequest(
                        verificationID: "test-verification-id",
                        verificationCode: "12345a"
                    )
                    
                    it("should throw invalidVerificationCode error") {
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await useCase.execute(request: nonNumericRequest)
                                    fail("Should throw error")
                                    done()
                                } catch let error as VerifyPhoneAuthCodeUseCaseError {
                                    expect(error).to(equal(.invalidVerificationCode))
                                    done()
                                } catch {
                                    fail("Should throw VerifyPhoneAuthCodeUseCaseError: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("with empty verification ID") {
                    let emptyIdRequest = VerifyPhoneAuthCodeUseCaseRequest(
                        verificationID: "",
                        verificationCode: "123456"
                    )
                    
                    it("should throw invalidVerificationCode error") {
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await useCase.execute(request: emptyIdRequest)
                                    fail("Should throw error")
                                    done()
                                } catch let error as VerifyPhoneAuthCodeUseCaseError {
                                    expect(error).to(equal(.invalidVerificationCode))
                                    done()
                                } catch {
                                    fail("Should throw VerifyPhoneAuthCodeUseCaseError: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("when repository throws network error") {
                    beforeEach {
                        mockPhoneAuthRepository.verifyCodeError = .networkError
                    }
                    
                    it("should throw networkError") {
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await useCase.execute(request: validRequest)
                                    fail("Should throw error")
                                    done()
                                } catch let error as VerifyPhoneAuthCodeUseCaseError {
                                    expect(error).to(equal(.networkError))
                                    done()
                                } catch {
                                    fail("Should throw VerifyPhoneAuthCodeUseCaseError: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("when repository throws invalid verification code error") {
                    beforeEach {
                        mockPhoneAuthRepository.verifyCodeError = .invalidVerificationCode
                    }
                    
                    it("should throw invalidVerificationCode error") {
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await useCase.execute(request: validRequest)
                                    fail("Should throw error")
                                    done()
                                } catch let error as VerifyPhoneAuthCodeUseCaseError {
                                    expect(error).to(equal(.invalidVerificationCode))
                                    done()
                                } catch {
                                    fail("Should throw VerifyPhoneAuthCodeUseCaseError: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("when repository throws verification code expired error") {
                    beforeEach {
                        mockPhoneAuthRepository.verifyCodeError = .verificationCodeExpired
                    }
                    
                    it("should throw verificationCodeExpired error") {
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await useCase.execute(request: validRequest)
                                    fail("Should throw error")
                                    done()
                                } catch let error as VerifyPhoneAuthCodeUseCaseError {
                                    expect(error).to(equal(.verificationCodeExpired))
                                    done()
                                } catch {
                                    fail("Should throw VerifyPhoneAuthCodeUseCaseError: \(error)")
                                    done()
                                }
                            }
                        }
                    }
                }
                
                context("when repository throws unknown error") {
                    beforeEach {
                        mockPhoneAuthRepository.verifyCodeError = .unknownError
                    }
                    
                    it("should throw unknown error") {
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await useCase.execute(request: validRequest)
                                    fail("Should throw error")
                                    done()
                                } catch let error as VerifyPhoneAuthCodeUseCaseError {
                                    expect(error).to(equal(.unknown))
                                    done()
                                } catch {
                                    fail("Should throw VerifyPhoneAuthCodeUseCaseError: \(error)")
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
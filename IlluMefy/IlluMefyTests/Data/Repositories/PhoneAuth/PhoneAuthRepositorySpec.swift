//
//  PhoneAuthRepositorySpec.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/05/30.
//

import Nimble
import Quick
import Foundation
@testable import IlluMefy

final class PhoneAuthRepositorySpec: QuickSpec, @unchecked Sendable {
    override class func spec() {
        var repository: PhoneAuthRepository!
        var mockFirebaseProvider: MockFirebasePhoneAuthProvider!
        
        describe("send an authencication code") {
            context("an enabled phone number") {
                beforeEach {
                    mockFirebaseProvider = MockFirebasePhoneAuthProvider()
                    mockFirebaseProvider.shouldSucceed = true
                    repository = PhoneAuthRepository(firebaseProvider: mockFirebaseProvider)
                }
                it("should return verification ID with the correct phone number") {
                    waitUntil { done in
                        Task {
                            do {
                                let response = try await repository.sendVerificationCode(
                                    request: SendVerificationCodeRequest(phoneNumber: "+819012345678")
                                )
                                
                                expect(response.verificationID).to(equal("mock-verification-id-123"))
                                expect(mockFirebaseProvider.verifyPhoneNumberCalled).to(beTrue())
                                expect(mockFirebaseProvider.lastPhoneNumber).to(equal("+819012345678"))
                                
                                done()
                            } catch {
                                fail("Unexpected error: \(error)")
                                done()
                            }
                        }
                    }
                }
            }
            
            context("a disabled phone number") {
                beforeEach {
                    mockFirebaseProvider = MockFirebasePhoneAuthProvider()
                    mockFirebaseProvider.shouldSucceed = false
                    mockFirebaseProvider.mockError = NSError(domain: "TestError", code: 123)
                    repository = PhoneAuthRepository(firebaseProvider: mockFirebaseProvider)
                }
                it("should throw error with the incorrect phone number") {
                    waitUntil { done in
                        Task {
                            do {
                                let _ = try await repository.sendVerificationCode(
                                    request: SendVerificationCodeRequest(phoneNumber: "0000000000")
                                )
                                fail("Expected error to be thrown")
                                done()
                            } catch let error as PhoneAuthRepositoryError {
                                expect(error).to(equal(.unknownError))
                                done()
                            }
                        }
                    }
                }
            }
        }
        
        describe("verify code and sign in") {
            context("valid verification code") {
                beforeEach {
                    mockFirebaseProvider = MockFirebasePhoneAuthProvider()
                    mockFirebaseProvider.shouldSucceed = true
                    repository = PhoneAuthRepository(firebaseProvider: mockFirebaseProvider)
                }
                
                it("should return user ID when verification code is correct") {
                    waitUntil { done in
                        Task {
                            do {
                                let response = try await repository.verifyCode(
                                    request: VerifyCodeRequest(
                                        verificationCode: "123456",
                                        verificationID: "mock-verification-id-123"
                                    )
                                )
                                
                                expect(response.userID).to(equal("mock-user-id-456"))
                                expect(mockFirebaseProvider.signInWithVerificationCodeCalled).to(beTrue())
                                
                                done()
                            } catch {
                                fail("Unexpected error: \(error)")
                                done()
                            }
                        }
                    }
                }
            }
            
            context("invalid verification code") {
                beforeEach {
                    mockFirebaseProvider = MockFirebasePhoneAuthProvider()
                    mockFirebaseProvider.shouldSucceed = false
                    mockFirebaseProvider.mockError = NSError(domain: "TestError", code: 456)
                    repository = PhoneAuthRepository(firebaseProvider: mockFirebaseProvider)
                }
                
                it("should throw error when verification code is incorrect") {
                    waitUntil { done in
                        Task {
                            do {
                                let _ = try await repository.verifyCode(
                                    request: VerifyCodeRequest(
                                        verificationCode: "000000",
                                        verificationID: "mock-verification-id-123"
                                    )
                                )
                                fail("Expected error to be thrown")
                                done()
                            } catch let error as PhoneAuthRepositoryError {
                                expect(error).to(equal(.unknownError))
                                done()
                            } catch {
                                fail("Unexpected error type: \(error)")
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}

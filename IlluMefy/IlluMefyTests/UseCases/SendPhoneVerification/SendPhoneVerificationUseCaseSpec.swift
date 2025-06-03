//
//  SendPhoneVerificationUseCaseSpec.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/05/31.
//

import Quick
import Nimble

final class SendPhoneVerificationUseCaseSpec: QuickSpec, @unchecked Sendable {
    override class func spec() {
        var mockRepository: MockPhoneAuthRepository!
        var usecase: SendPhoneVerificationUseCase!
        var request: SendPhoneVerificationUseCaseRequest!
        
        describe("send verification code") {
            beforeEach {
                mockRepository = MockPhoneAuthRepository()
                usecase = SendPhoneVerificationUseCase(phoneAuthRepository: mockRepository)
            }
            
            context("with a valid phone number") {
                let givePhoneNumber = "09012345678"
                let expectPhoneNumber = "+819012345678"
                let expectVerificationId = "test-verification-id"
                
                beforeEach {
                    mockRepository.expectedVerificationID = expectVerificationId
                    mockRepository.sendVerificationCodeError = nil
                    request = SendPhoneVerificationUseCaseRequest(phoneNumber: givePhoneNumber)
                }
                
                it("should return the SendPhoneVerificationUseCaseResponse data") {
                    waitUntil { done in
                        Task {
                            let response = try await usecase.execute(request: request)
                            expect(response.verificationID).to(equal(expectVerificationId))
                            expect(mockRepository.isSendVerificationCodeCalled).to(beTrue())
                            expect(mockRepository.givenRequest.phoneNumber).to(equal(expectPhoneNumber))
                            done()
                        }
                    }
                }
                
                it("should throw network error when repository returns network error") {
                    waitUntil { done in
                        Task {
                            mockRepository.sendVerificationCodeError = .networkError
                            
                            do {
                                _ = try await usecase.execute(request: request)
                                fail("Expected error but succeeded")
                            } catch let error as SendPhoneVerificationUseCaseError {
                                expect(error).to(equal(.networkError))
                                expect(mockRepository.isSendVerificationCodeCalled).to(beTrue())
                            } catch {
                                fail("Unexpected error type: \(error)")
                            }
                            done()
                        }
                    }
                }
                
                it("should throw quota exceeded error when repository returns quota exceeded") {
                    waitUntil { done in
                        Task {
                            mockRepository.sendVerificationCodeError = .quotaExceeded
                            
                            do {
                                _ = try await usecase.execute(request: request)
                                fail("Expected error but succeeded")
                            } catch let error as SendPhoneVerificationUseCaseError {
                                expect(error).to(equal(.quotaExceeded))
                            } catch {
                                fail("Unexpected error type: \(error)")
                            }
                            done()
                        }
                    }
                }
            }
            
            context("with an invalid phone number") {
                it("should throw invalid phone number error for empty string") {
                    waitUntil { done in
                        Task {
                            request = SendPhoneVerificationUseCaseRequest(phoneNumber: "")
                            
                            do {
                                _ = try await usecase.execute(request: request)
                                fail("Expected error but succeeded")
                            } catch let error as SendPhoneVerificationUseCaseError {
                                expect(error).to(equal(.invalidPhoneNumber))
                                expect(mockRepository.isSendVerificationCodeCalled).to(beFalse())
                            } catch {
                                fail("Unexpected error type: \(error)")
                            }
                            done()
                        }
                    }
                }
                
                it("should throw invalid phone number error for too short number") {
                    waitUntil { done in
                        Task {
                            request = SendPhoneVerificationUseCaseRequest(phoneNumber: "090123")
                            
                            do {
                                _ = try await usecase.execute(request: request)
                                fail("Expected error but succeeded")
                            } catch let error as SendPhoneVerificationUseCaseError {
                                expect(error).to(equal(.invalidPhoneNumber))
                                expect(mockRepository.isSendVerificationCodeCalled).to(beFalse())
                            } catch {
                                fail("Unexpected error type: \(error)")
                            }
                            done()
                        }
                    }
                }
                
                it("should throw invalid phone number error for too long number") {
                    waitUntil { done in
                        Task {
                            request = SendPhoneVerificationUseCaseRequest(phoneNumber: "090123456789")
                            
                            do {
                                _ = try await usecase.execute(request: request)
                                fail("Expected error but succeeded")
                            } catch let error as SendPhoneVerificationUseCaseError {
                                expect(error).to(equal(.invalidPhoneNumber))
                                expect(mockRepository.isSendVerificationCodeCalled).to(beFalse())
                            } catch {
                                fail("Unexpected error type: \(error)")
                            }
                            done()
                        }
                    }
                }
            }
            
            context("with phone number formatting") {
                it("should format phone number with hyphens to E.164") {
                    waitUntil { done in
                        Task {
                            request = SendPhoneVerificationUseCaseRequest(phoneNumber: "090-1234-5678")
                            mockRepository.expectedVerificationID = "test-id"
                            
                            let response = try await usecase.execute(request: request)
                            expect(response.verificationID).to(equal("test-id"))
                            expect(mockRepository.givenRequest.phoneNumber).to(equal("+819012345678"))
                            done()
                        }
                    }
                }
                
                it("should handle already formatted international number") {
                    waitUntil { done in
                        Task {
                            request = SendPhoneVerificationUseCaseRequest(phoneNumber: "+819012345678")
                            mockRepository.expectedVerificationID = "test-id"
                            
                            let response = try await usecase.execute(request: request)
                            expect(response.verificationID).to(equal("test-id"))
                            expect(mockRepository.givenRequest.phoneNumber).to(equal("+819012345678"))
                            done()
                        }
                    }
                }
                
                it("should format landline number (10 digits) to E.164") {
                    waitUntil { done in
                        Task {
                            request = SendPhoneVerificationUseCaseRequest(phoneNumber: "0312345678")
                            mockRepository.expectedVerificationID = "test-id"
                            
                            let response = try await usecase.execute(request: request)
                            expect(response.verificationID).to(equal("test-id"))
                            expect(mockRepository.givenRequest.phoneNumber).to(equal("+81312345678"))
                            done()
                        }
                    }
                }
            }
        }
    }
}
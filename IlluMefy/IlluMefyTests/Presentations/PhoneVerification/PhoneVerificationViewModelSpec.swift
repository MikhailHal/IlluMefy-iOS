//
//  PhoneVerificationViewModelSpec.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/06.
//

import Quick
import Nimble
@testable import IlluMefy

@MainActor
final class PhoneVerificationViewModelSpec: QuickSpec, @unchecked Sendable {
    override class func spec() {
        var viewModel: PhoneVerificationViewModel!
        var mockVerifyPhoneAuthCodeUseCase: MockVerifyPhoneAuthCodeUseCase!
        var mockSendPhoneVerificationUseCase: MockSendPhoneVerificationUseCase!
        
        describe("PhoneVerificationViewModel") {
            beforeEach {
                mockVerifyPhoneAuthCodeUseCase = MockVerifyPhoneAuthCodeUseCase()
                mockSendPhoneVerificationUseCase = MockSendPhoneVerificationUseCase()
                
                viewModel = PhoneVerificationViewModel(
                    verificationID: "test-verification-id",
                    phoneNumber: "09012345678",
                    verifyPhoneAuthCodeUseCase: mockVerifyPhoneAuthCodeUseCase,
                    sendPhoneVerificationUseCase: mockSendPhoneVerificationUseCase
                )
            }
            
            context("initialization") {
                it("should initialize with default values") {
                    expect(viewModel.verificationCode).to(equal(""))
                    expect(viewModel.isShowErrorDialog).to(beFalse())
                    expect(viewModel.errorDialogMessage).to(equal(""))
                    expect(viewModel.isShowNotificationDialog).to(beFalse())
                    expect(viewModel.notificationDialogMessage).to(equal(""))
                    expect(viewModel.isLoading).to(beFalse())
                    expect(viewModel.resendCooldownSeconds).to(equal(0))
                }
                
                it("should have correct computed properties initially") {
                    expect(viewModel.isRegisterButtonEnabled).to(beFalse())
                    expect(viewModel.isResendButtonEnabled).to(beTrue())
                }
            }
            
            context("isRegisterButtonEnabled") {
                it("should be false when verification code is empty") {
                    viewModel.verificationCode = ""
                    expect(viewModel.isRegisterButtonEnabled).to(beFalse())
                }
                
                it("should be false when verification code is less than 6 digits") {
                    viewModel.verificationCode = "12345"
                    expect(viewModel.isRegisterButtonEnabled).to(beFalse())
                }
                
                it("should be true when verification code is exactly 6 digits") {
                    viewModel.verificationCode = "123456"
                    expect(viewModel.isRegisterButtonEnabled).to(beTrue())
                }
                
                it("should be false when loading") {
                    viewModel.verificationCode = "123456"
                    viewModel.isLoading = true
                    expect(viewModel.isRegisterButtonEnabled).to(beFalse())
                }
            }
            
            context("isResendButtonEnabled") {
                it("should be true when cooldown is 0 and not loading") {
                    viewModel.resendCooldownSeconds = 0
                    viewModel.isLoading = false
                    expect(viewModel.isResendButtonEnabled).to(beTrue())
                }
                
                it("should be false when cooldown is active") {
                    viewModel.resendCooldownSeconds = 30
                    viewModel.isLoading = false
                    expect(viewModel.isResendButtonEnabled).to(beFalse())
                }
                
                it("should be false when loading") {
                    viewModel.resendCooldownSeconds = 0
                    viewModel.isLoading = true
                    expect(viewModel.isResendButtonEnabled).to(beFalse())
                }
            }
            
            context("registerAccount") {
                beforeEach {
                    viewModel.verificationCode = "123456"
                }
                
                context("when verification succeeds") {
                    beforeEach {
                        mockVerifyPhoneAuthCodeUseCase.shouldSucceed = true
                    }
                    
                    it("should complete successfully and show success dialog") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.registerAccount()
                                
                                expect(viewModel.isShowNotificationDialog).to(beTrue())
                                expect(viewModel.notificationDialogMessage).to(equal(L10n.PhoneVerification.Message.accountCreated))
                                expect(viewModel.isShowErrorDialog).to(beFalse())
                                expect(viewModel.isLoading).to(beFalse())
                                
                                expect(mockVerifyPhoneAuthCodeUseCase.executeCallCount).to(equal(1))
                                
                                // Verify the verification request
                                let verifyRequest = mockVerifyPhoneAuthCodeUseCase.lastExecutedRequest
                                expect(verifyRequest?.verificationID).to(equal("test-verification-id"))
                                expect(verifyRequest?.verificationCode).to(equal("123456"))
                                
                                done()
                            }
                        }
                    }
                }
                
                context("when verification fails") {
                    beforeEach {
                        mockVerifyPhoneAuthCodeUseCase.shouldSucceed = false
                        mockVerifyPhoneAuthCodeUseCase.mockError = .invalidVerificationCode
                    }
                    
                    it("should show error dialog") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.registerAccount()
                                
                                expect(viewModel.isShowErrorDialog).to(beTrue())
                                expect(viewModel.errorDialogMessage).to(equal(VerifyPhoneAuthCodeUseCaseError.invalidVerificationCode.errorDescription))
                                expect(viewModel.isShowNotificationDialog).to(beFalse())
                                expect(viewModel.isLoading).to(beFalse())
                                
                                expect(mockVerifyPhoneAuthCodeUseCase.executeCallCount).to(equal(1))
                                
                                done()
                            }
                        }
                    }
                }
                
                
                context("when unexpected error occurs") {
                    beforeEach {
                        mockVerifyPhoneAuthCodeUseCase.shouldSucceed = false
                        mockVerifyPhoneAuthCodeUseCase.shouldThrowUnexpectedError = true
                    }
                    
                    it("should show generic error dialog") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.registerAccount()
                                
                                expect(viewModel.isShowErrorDialog).to(beTrue())
                                expect(viewModel.errorDialogMessage).to(equal(L10n.PhoneAuth.Error.unknownError))
                                expect(viewModel.isShowNotificationDialog).to(beFalse())
                                expect(viewModel.isLoading).to(beFalse())
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("resendVerificationCode") {
                context("when resend succeeds") {
                    beforeEach {
                        mockSendPhoneVerificationUseCase.shouldSucceed = true
                    }
                    
                    it("should start cooldown timer") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.resendVerificationCode()
                                
                                expect(viewModel.resendCooldownSeconds).to(equal(60))
                                expect(viewModel.isLoading).to(beFalse())
                                expect(mockSendPhoneVerificationUseCase.executeCallCount).to(equal(1))
                                
                                let request = mockSendPhoneVerificationUseCase.lastExecutedRequest
                                expect(request?.phoneNumber).to(equal("09012345678"))
                                
                                done()
                            }
                        }
                    }
                }
                
                context("when resend fails") {
                    beforeEach {
                        mockSendPhoneVerificationUseCase.shouldSucceed = false
                        mockSendPhoneVerificationUseCase.mockError = .networkError
                    }
                    
                    it("should show error dialog") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.resendVerificationCode()
                                
                                expect(viewModel.isShowErrorDialog).to(beTrue())
                                expect(viewModel.errorDialogMessage).to(equal(L10n.PhoneAuth.Error.failedToSendCode))
                                expect(viewModel.isLoading).to(beFalse())
                                expect(mockSendPhoneVerificationUseCase.executeCallCount).to(equal(1))
                                
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
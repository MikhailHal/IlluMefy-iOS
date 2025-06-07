//
//  PhoneNumberRegistrationViewModelSpec.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/04.
//

import Quick
import Nimble
@testable import IlluMefy

@MainActor
final class PhoneNumberRegistrationViewModelSpec: QuickSpec, @unchecked Sendable {
    override class func spec() {
        var viewModel: PhoneNumberRegistrationViewModel!
        var mockSendPhoneVerificationUseCase: MockSendPhoneVerificationUseCase!
        
        describe("PhoneNumberRegistrationViewModel") {
            beforeEach {
                mockSendPhoneVerificationUseCase = MockSendPhoneVerificationUseCase()
                
                viewModel = PhoneNumberRegistrationViewModel(
                    sendPhoneVerificationUseCase: mockSendPhoneVerificationUseCase
                )
            }
            
            context("initialization") {
                it("should initialize with default values") {
                    expect(viewModel.errorDialogMessage).to(equal(""))
                    expect(viewModel.notificationDialogMessage).to(equal(""))
                    expect(viewModel.verificationID).to(beNil())
                    expect(viewModel.isShowErrorDialog).to(beFalse())
                    expect(viewModel.isShowNotificationDialog).to(beFalse())
                    expect(viewModel.isEnableRegisterButton).to(beFalse())
                    expect(viewModel.email).to(equal(""))
                    expect(viewModel.password).to(equal(""))
                    expect(viewModel.phoneNumber).to(equal(""))
                    expect(viewModel.isShowTermsOfServiceBottomSheet).to(beFalse())
                    expect(viewModel.isShowPrivacyPolicyBottomSheet).to(beFalse())
                    expect(viewModel.isAgreedTermsOfService).to(beFalse())
                    expect(viewModel.allowedPasswordMinLength).to(equal(6))
                }
                
                it("should have correct use case dependencies") {
                    expect(viewModel.sendPhoneVerificationUseCase).toNot(beNil())
                }
            }
            
            context("sendVerificationCode") {
                context("with valid phone number") {
                    let testPhoneNumber = "09012345678"
                    let expectedVerificationID = "test-verification-id-123"
                    
                    beforeEach {
                        mockSendPhoneVerificationUseCase.shouldSucceed = true
                        mockSendPhoneVerificationUseCase.mockVerificationID = expectedVerificationID
                        viewModel.phoneNumber = testPhoneNumber
                    }
                    
                    it("should set verificationID and show notification dialog on success") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.sendVerificationCode()
                                expect(viewModel.verificationID).to(equal(expectedVerificationID))
                                expect(viewModel.isShowNotificationDialog).to(beTrue())
                                expect(viewModel.notificationDialogMessage).to(equal(L10n.PhoneNumberRegistration.Message.verificationCodeSent))
                                expect(viewModel.isShowErrorDialog).to(beFalse())
                                expect(mockSendPhoneVerificationUseCase.executeCallCount).to(equal(1))
                                expect(mockSendPhoneVerificationUseCase.lastExecutedRequest?.phoneNumber).to(equal(testPhoneNumber))
                                done()
                            }
                        }
                    }
                }
                
                context("with use case error") {
                    beforeEach {
                        mockSendPhoneVerificationUseCase.shouldSucceed = false
                        mockSendPhoneVerificationUseCase.mockError = .networkError
                        viewModel.phoneNumber = "09012345678"
                    }
                    
                    it("should show error dialog when use case fails") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.sendVerificationCode()
                                expect(viewModel.isShowErrorDialog).to(beTrue())
                                expect(viewModel.errorDialogMessage).to(equal(SendPhoneVerificationUseCaseError.networkError.errorDescription))
                                expect(viewModel.isShowNotificationDialog).to(beFalse())
                                expect(viewModel.verificationID).to(beNil())
                                expect(viewModel.notificationDialogMessage).to(equal(""))
                                done()
                            }
                        }
                    }
                }
                
                context("with unexpected error") {
                    beforeEach {
                        mockSendPhoneVerificationUseCase.shouldSucceed = false
                        mockSendPhoneVerificationUseCase.shouldThrowUnexpectedError = true
                        viewModel.phoneNumber = "09012345678"
                    }
                    
                    it("should show generic error dialog for unexpected errors") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.sendVerificationCode()
                                expect(viewModel.isShowErrorDialog).to(beTrue())
                                expect(viewModel.errorDialogMessage).to(equal(L10n.PhoneAuth.Error.unknownError))
                                expect(viewModel.isShowNotificationDialog).to(beFalse())
                                expect(viewModel.verificationID).to(beNil())
                                expect(viewModel.notificationDialogMessage).to(equal(""))
                                done()
                            }
                        }
                    }
                }
                
                context("with invalid phone number") {
                    beforeEach {
                        mockSendPhoneVerificationUseCase.shouldSucceed = false
                        mockSendPhoneVerificationUseCase.mockError = .invalidPhoneNumber
                        viewModel.phoneNumber = ""
                    }
                    
                    it("should show invalid phone number error") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.sendVerificationCode()
                                expect(viewModel.isShowErrorDialog).to(beTrue())
                                expect(viewModel.errorDialogMessage).to(equal(SendPhoneVerificationUseCaseError.invalidPhoneNumber.errorDescription))
                                expect(viewModel.isShowNotificationDialog).to(beFalse())
                                expect(viewModel.verificationID).to(beNil())
                                done()
                            }
                        }
                    }
                }
            }
            
            context("sendAuthenticationCode") {
                it("should call sendVerificationCode internally") {
                    let testPhoneNumber = "09012345678"
                    let expectedVerificationID = "test-verification-id-456"
                    
                    mockSendPhoneVerificationUseCase.shouldSucceed = true
                    mockSendPhoneVerificationUseCase.mockVerificationID = expectedVerificationID
                    viewModel.phoneNumber = testPhoneNumber
                    
                    waitUntil(timeout: .seconds(3)) { done in
                        Task {
                            await viewModel.sendAuthenticationCode()
                            expect(viewModel.verificationID).to(equal(expectedVerificationID))
                            expect(viewModel.isShowNotificationDialog).to(beTrue())
                            expect(viewModel.notificationDialogMessage).to(equal(L10n.PhoneNumberRegistration.Message.verificationCodeSent))
                            expect(mockSendPhoneVerificationUseCase.executeCallCount).to(equal(1))
                            expect(mockSendPhoneVerificationUseCase.lastExecutedRequest?.phoneNumber).to(equal(testPhoneNumber))
                            done()
                        }
                    }
                }
            }
            
            context("property updates") {
                it("should properly update phoneNumber property") {
                    let testPhoneNumber = "09087654321"
                    viewModel.phoneNumber = testPhoneNumber
                    expect(viewModel.phoneNumber).to(equal(testPhoneNumber))
                }
                
                it("should properly update email property") {
                    let testEmail = "test@example.com"
                    viewModel.email = testEmail
                    expect(viewModel.email).to(equal(testEmail))
                }
                
                it("should properly update password property") {
                    let testPassword = "password123"
                    viewModel.password = testPassword
                    expect(viewModel.password).to(equal(testPassword))
                }
                
                it("should properly update agreement flags") {
                    viewModel.isAgreedTermsOfService = true
                    expect(viewModel.isAgreedTermsOfService).to(beTrue())
                }
            }
        }
    }
}

//
//  PhoneVerificationViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//

import Combine
import Foundation

@MainActor
final class PhoneVerificationViewModel: PhoneVerificationViewModelProtocol {
    // MARK: - Properties
    
    @Published var verificationCode: String = ""
    @Published var isShowErrorDialog: Bool = false
    @Published var errorDialogMessage: String = ""
    @Published var isShowNotificationDialog: Bool = false
    @Published var notificationDialogMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var resendCooldownSeconds: Int = 0
    
    /// Firebase認証用のverificationID
    private var verificationID: String
    
    /// 電話番号
    private let phoneNumber: String

    /// 電話番号認証コード検証ユースケース
    private let verifyPhoneAuthCodeUseCase: any VerifyPhoneAuthCodeUseCaseProtocol
    
    /// 電話番号認証送信ユースケース（再送信用）
    private let sendPhoneVerificationUseCase: any SendPhoneVerificationUseCaseProtocol
    
    /// 再送信タイマー
    private var resendTimer: Timer?
    
    // MARK: - Computed Properties
    
    var isRegisterButtonEnabled: Bool {
        !verificationCode.isEmpty && 
        verificationCode.count == 6 && 
        !isLoading
    }
    
    var isResendButtonEnabled: Bool {
        resendCooldownSeconds == 0 && !isLoading
    }
    
    // MARK: - Initialization
    
    init(
        verificationID: String,
        phoneNumber: String,
        verifyPhoneAuthCodeUseCase: any VerifyPhoneAuthCodeUseCaseProtocol,
        sendPhoneVerificationUseCase: any SendPhoneVerificationUseCaseProtocol
    ) {
        self.verificationID = verificationID
        self.phoneNumber = phoneNumber
        self.verifyPhoneAuthCodeUseCase = verifyPhoneAuthCodeUseCase
        self.sendPhoneVerificationUseCase = sendPhoneVerificationUseCase
    }
    
    // MARK: - Methods
    
    func registerAccount() async {
        isLoading = true
        
        do {
            // 認証番号検証（Firebase SMS認証では自動でアカウント作成/サインイン）
            let verifyRequest = VerifyPhoneAuthCodeUseCaseRequest(
                verificationID: verificationID,
                verificationCode: verificationCode
            )
            _ = try await verifyPhoneAuthCodeUseCase.execute(request: verifyRequest)
            
            // 成功通知
            notificationDialogMessage = L10n.PhoneVerification.Message.accountCreated
            isShowNotificationDialog = true
            
        } catch let error as VerifyPhoneAuthCodeUseCaseError {
            errorDialogMessage = error.errorDescription ?? L10n.PhoneAuth.Error.unknownError
            isShowErrorDialog = true
        } catch {
            errorDialogMessage = L10n.PhoneAuth.Error.unknownError
            isShowErrorDialog = true
        }
        
        isLoading = false
    }
    
    func resendVerificationCode() async {
        isLoading = true
        
        do {
            let request = SendPhoneVerificationUseCaseRequest(phoneNumber: phoneNumber)
            let response = try await sendPhoneVerificationUseCase.execute(request: request)
            
            // 新しいverificationIDを更新
            verificationID = response.verificationID
            
            // 入力済みの認証番号をクリア（新しいコードを入力してもらうため）
            verificationCode = ""
            
            // クールダウン開始
            startResendCooldown()
            
        } catch {
            errorDialogMessage = L10n.PhoneAuth.Error.failedToSendCode
            isShowErrorDialog = true
        }
        
        isLoading = false
    }
    
    // MARK: - Private Methods
    private func startResendCooldown() {
        resendCooldownSeconds = 60
        
        resendTimer?.invalidate()
        resendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                
                if self.resendCooldownSeconds > 0 {
                    self.resendCooldownSeconds -= 1
                } else {
                    self.resendTimer?.invalidate()
                    self.resendTimer = nil
                }
            }
        }
    }
    
    deinit {
        resendTimer?.invalidate()
    }
}

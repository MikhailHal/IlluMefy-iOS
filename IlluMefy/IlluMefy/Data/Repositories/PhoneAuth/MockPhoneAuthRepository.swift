//
//  MockPhoneAuthRepository.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/05/31.
//

import Foundation

class MockPhoneAuthRepository: PhoneAuthRepositoryProtocol {
    // sendVerificationCodeが呼ばれたかどうか
    var isSendVerificationCodeCalled = false
    // 返却するverificationIDを設定
    var expectedVerificationID = "test-verification-id"
    // sendVerificationCode用のエラーを設定
    var sendVerificationCodeError: PhoneAuthRepositoryError?
    // 渡されたリクエストを保持
    var givenRequest = SendVerificationCodeRequest(phoneNumber: "")
    
    // verifyCodeが呼ばれたかどうか
    var isVerifyCodeCalled = false
    // 返却するuserIDを設定
    var expectedUserID = "test-user-id"
    // verifyCode用のエラーを設定
    var verifyCodeError: PhoneAuthRepositoryError?
    
    init(firebaseProvider: FirebasePhoneAuthProviderProtocol = FirebasePhoneAuthProvider()) {
        _ = firebaseProvider
    }
    
    /// 認証コードを送信
    func sendVerificationCode(request: SendVerificationCodeRequest) async throws -> SendVerificationCodeResponse {
        isSendVerificationCodeCalled = true
        givenRequest = request
        
        if let error = sendVerificationCodeError {
            throw error
        }
        
        return SendVerificationCodeResponse(verificationID: expectedVerificationID)
    }
    
    /// 認証コードを検証してサインイン
    func verifyCode(request: VerifyCodeRequest) async throws -> VerifyCodeResponse {
        isVerifyCodeCalled = true
        
        if let error = verifyCodeError {
            throw error
        }
        
        return VerifyCodeResponse(userID: expectedUserID)
    }
}

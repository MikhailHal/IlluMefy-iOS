//
//  FirebasePhoneAuthProviderProtocol.swift
//  IlluMefy
//
//  Firebase Phone Authentication プロバイダーのプロトコル
//

import Foundation
import FirebaseAuth

/// Firebase Phone Authenticationの機能を抽象化するプロトコル
protocol FirebasePhoneAuthProviderProtocol: Sendable {
    /// 電話番号認証のコードを送信
    func verifyPhoneNumber(_ phoneNumber: String, uiDelegate: AuthUIDelegate?, completion: @escaping (String?, Error?) -> Void)
    
    /// 認証コードでサインイン（クレデンシャル作成も含む）
    func signInWithVerificationCode(verificationID: String, verificationCode: String) async throws -> String
}

/// Firebase実装
final class FirebasePhoneAuthProvider: FirebasePhoneAuthProviderProtocol {
    func verifyPhoneNumber(_ phoneNumber: String, uiDelegate: AuthUIDelegate?, completion: @escaping (String?, Error?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: uiDelegate, completion: completion)
    }
    
    func signInWithVerificationCode(verificationID: String, verificationCode: String) async throws -> String {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        let authResult = try await Auth.auth().signIn(with: credential)
        return authResult.user.uid
    }
}

/// テスト用モック
final class MockFirebasePhoneAuthProvider: FirebasePhoneAuthProviderProtocol, @unchecked Sendable {
    // テスト制御用プロパティ
    var shouldSucceed = true
    var mockVerificationID = "mock-verification-id-123"
    var mockUserID = "mock-user-id-456"
    var mockError: Error?
    
    // 呼び出し確認用
    var verifyPhoneNumberCalled = false
    var lastPhoneNumber: String?
    var signInWithVerificationCodeCalled = false
    
    func verifyPhoneNumber(_ phoneNumber: String, uiDelegate: AuthUIDelegate?, completion: @escaping (String?, Error?) -> Void) {
        verifyPhoneNumberCalled = true
        lastPhoneNumber = phoneNumber
        
        if shouldSucceed {
            completion(mockVerificationID, nil)
        } else {
            completion(nil, mockError ?? NSError(domain: "TestError", code: 123))
        }
    }
    
    func signInWithVerificationCode(verificationID: String, verificationCode: String) async throws -> String {
        signInWithVerificationCodeCalled = true
        
        if shouldSucceed {
            return mockUserID
        } else {
            throw mockError ?? NSError(domain: "TestError", code: 456)
        }
    }
}

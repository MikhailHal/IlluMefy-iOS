//
//  AccountLoginRepository.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

import FirebaseAuth

final class AccountLoginRepository: AccountLoginRepositoryProtocol {
    func login(_ request: AccountLoginRequest) async throws -> Bool {
        do {
            // For phone number authentication, we would typically use Firebase Phone Auth
            // For now, treating phone number as email for compatibility
            // In a real implementation, this would use Firebase Phone Authentication
            try await Auth.auth().signIn(withEmail: request.phoneNumber, password: request.password)
            return true
        } catch {
            throw AccountLoginRepositoryError.from(error)
        }
    }
    
    func createAccount(request: CreateAccountRequest) async throws -> CreateAccountResponse {
        do {
            // Firebase Phone Auth credentialを生成してサインイン
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: request.verificationID,
                verificationCode: request.verificationCode
            )
            
            let authResult = try await Auth.auth().signIn(with: credential)
            let user = authResult.user
            
            // 追加のユーザー情報をFirestoreなどに保存する場合はここで実行
            // 例: Firestore.firestore().collection("users").document(user.uid).setData(...)
            
            return CreateAccountResponse(
                userID: user.uid,
                phoneNumber: request.phoneNumber
            )
        } catch {
            throw AccountLoginRepositoryError.from(error)
        }
    }
}

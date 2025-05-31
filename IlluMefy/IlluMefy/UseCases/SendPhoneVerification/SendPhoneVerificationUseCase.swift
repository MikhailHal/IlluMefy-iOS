//
//  SendPhoneVerificationUseCase.swift
//  IlluMefy
//
//  電話番号認証コード送信ユースケースの実装
//

import Foundation

/// 電話番号認証コード送信ユースケースの実装
final class SendPhoneVerificationUseCase: SendPhoneVerificationUseCaseProtocol {
    
    // MARK: - Properties
    
    private let phoneAuthRepository: PhoneAuthRepositoryProtocol
    
    // MARK: - Initialization
    
    init(phoneAuthRepository: PhoneAuthRepositoryProtocol) {
        self.phoneAuthRepository = phoneAuthRepository
    }
    
    // MARK: - SendPhoneVerificationUseCaseProtocol
    
    func execute(request: SendPhoneVerificationUseCaseRequest) async throws -> SendPhoneVerificationUseCaseResponse {
        // パラメータバリデーション
        _ = try checkParameterValidation(request: request)
        
        // 国内番号をE.164形式に変換
        let formattedNumber = formatToE164(request.phoneNumber)
        
        do {
            let request = SendVerificationCodeRequest(phoneNumber: formattedNumber)
            let response = try await phoneAuthRepository.sendVerificationCode(request: request)
            return SendPhoneVerificationUseCaseResponse(verificationID: response.verificationID)
        } catch let error as PhoneAuthRepositoryError {
            // リポジトリエラーをユースケースエラーに変換
            throw mapRepositoryError(error)
        } catch {
            throw SendPhoneVerificationUseCaseError.unknown
        }
    }
    
    func checkParameterValidation(request: SendPhoneVerificationUseCaseRequest) throws ->
    SendPhoneVerificationUseCaseError {
        // 電話番号のバリデーション
        guard isValidPhoneNumber(request.phoneNumber) else {
            throw SendPhoneVerificationUseCaseError.invalidPhoneNumber
        }
        // バリデーション成功時はsuccessを返す
        return .success
    }
    
    // MARK: - Private Methods
    
    /// 電話番号の形式を検証
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // 国際形式（+81で始まる）の場合
        if phoneNumber.hasPrefix("+81") {
            let digitsOnly = phoneNumber.dropFirst(3).filter { $0.isNumber }
            return digitsOnly.count == 9 || digitsOnly.count == 10
        }
        
        // 国内形式の場合
        let digitsOnly = phoneNumber.filter { $0.isNumber }
        return digitsOnly.count == 10 || digitsOnly.count == 11
    }
    
    /// 国内番号をE.164形式に変換
    /// 例: 09012345678 → +819012345678
    private func formatToE164(_ phoneNumber: String) -> String {
        let digitsOnly = phoneNumber.filter { $0.isNumber }
        
        // 先頭の0を削除して+81を追加
        if digitsOnly.hasPrefix("0") {
            return "+81" + digitsOnly.dropFirst()
        }
        
        // すでに国際形式の場合はそのまま返す
        if phoneNumber.hasPrefix("+") {
            return phoneNumber
        }
        
        // それ以外は+81を付けて返す
        return "+81" + digitsOnly
    }
    
    /// リポジトリエラーをユースケースエラーにマッピング
    private func mapRepositoryError(_ error: PhoneAuthRepositoryError) -> SendPhoneVerificationUseCaseError {
        switch error {
        case .invalidPhoneNumber:
            return .invalidPhoneNumber
        case .networkError:
            return .networkError
        case .quotaExceeded:
            return .quotaExceeded
        default:
            return .unknown
        }
    }
}

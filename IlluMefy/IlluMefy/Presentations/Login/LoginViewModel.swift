//
//  LoginViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/02.
//

import Combine

@MainActor
class LoginViewModel: LoginViewModelProtocol {
    func initializeStoredLoginAccountData() async {
        let storeData = getStoreLoginAccountInLocalUseCase.getStoreData()
        if storeData.isStore == true {
            await MainActor.run {
                phoneNumber = storeData.email // Note: Keeping email field for backward compatibility with stored data
                password = storeData.password
                isStoreLoginInformation = true
                hasStoredLoginInfo = true
            }
        } else {
            await MainActor.run {
                hasStoredLoginInfo = false
            }
        }
    }
    
    var setStoreLoginAccountInLocalUseCase: any SetStoreLoginAccountInLocalUseCaseProtocol
    var getStoreLoginAccountInLocalUseCase: any GetStoreLoginAccountInLocalUseCaseProtocol
    var loginUseCase: any AccountLoginUseCaseProtocol
    var errorDialogMessage: String = ""
    var notificationDialogMessage: String = ""
    @Published var isShowNotificationDialog: Bool = false
    @Published var isShowErrorDialog: Bool = false
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var isStoreLoginInformation: Bool = false
    @Published var hasStoredLoginInfo: Bool = false
    
    var isValid: Bool {
        !phoneNumber.isEmpty && password.count >= 6
    }
    
    init(
        loginUseCase: any AccountLoginUseCaseProtocol,
        setStoreLoginAccountInLocalUseCase: any SetStoreLoginAccountInLocalUseCaseProtocol,
        getStoreLoginAccountInLocalUseCase: any GetStoreLoginAccountInLocalUseCaseProtocol
    ) {
        self.loginUseCase = loginUseCase
        self.setStoreLoginAccountInLocalUseCase = setStoreLoginAccountInLocalUseCase
        self.getStoreLoginAccountInLocalUseCase = getStoreLoginAccountInLocalUseCase
    }

    func login() async {
        do {
            let (phoneNumber, password, isStoreLoginInformation) = await MainActor.run {
                (self.phoneNumber, self.password, self.isStoreLoginInformation)
            }
            
            _ = try await loginUseCase.execute(
                request: AccountLoginUseCaseRequest(
                    phoneNumber: phoneNumber,
                    password: password
                )
            )
            if isStoreLoginInformation {
                _ = setStoreLoginAccountInLocalUseCase.setStoreData(
                    request: SetStoreLoginAccountInLocalUseCaseRequest(
                        email: phoneNumber, // Store phone number in email field for backward compatibility
                        password: password,
                        isStore: true
                    )
                )
            }
            await MainActor.run {
                notificationDialogMessage = "ログインに成功しました。"
                isShowNotificationDialog = true
            }
        } catch {
            let usecaseError = error as? AccountLoginUseCaseError
            switch usecaseError {
            case
                .invalidEmail,
                .wrongPassword,
                .invalidCredential,
                .userNotFound:
                    errorDialogMessage = "電話番号またはパスワードが間違っています。"
                
            case .userDisabled:
                errorDialogMessage = "このアカウントからのアクセスは禁止されています。"
            
            case .tooManyRequests:
                errorDialogMessage = "大量のアクセスが検知されました。時間を置いてから再度お試しください。"
                
            case .networkError:
                errorDialogMessage = "ネットワーク回線状況をお確かめください。"
                
            case .unknown:
                errorDialogMessage = "予期せぬエラーが発生しました。"
                
            default:
                errorDialogMessage = "予期せぬエラーが発生しました。"
            }
            await MainActor.run {
                isShowErrorDialog = true
            }
        }
    }
}

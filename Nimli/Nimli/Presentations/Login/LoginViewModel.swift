//
//  LoginViewModel.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/02.
//

import Combine
class LoginViewModel: LoginViewModelProtocol {
    var setStoreLoginAccountInLocalUseCase: any SetStoreLoginAccountInLocalUseCaseProtocol
    var getStoreLoginAccountInLocalUseCase: any GetStoreLoginAccountInLocalUseCaseProtocol
    var loginUseCase: any AccountLoginUseCaseProtocol
    var errorDialogMessage: String = ""
    var notificationDialogMessage: String = ""
    @Published var isShowNotificationDialog: Bool = false
    @Published var isShowErrorDialog: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isStoreLoginInformation: Bool = false
    
    init(
        loginUseCase: any AccountLoginUseCaseProtocol,
        setStoreLoginAccountInLocalUseCase: any SetStoreLoginAccountInLocalUseCaseProtocol,
        getStoreLoginAccountInLocalUseCase: any GetStoreLoginAccountInLocalUseCaseProtocol
    ) {
        self.loginUseCase = loginUseCase
        self.setStoreLoginAccountInLocalUseCase = setStoreLoginAccountInLocalUseCase
        self.getStoreLoginAccountInLocalUseCase = getStoreLoginAccountInLocalUseCase
    }
    
    func initializeStoedLoginAccountData() async {
        let storeData = getStoreLoginAccountInLocalUseCase.getStoreData()
        if storeData.isStore == true {
            email = storeData.email
            password = storeData.password
        }
    }
    
    func login() async {
        do {
            _ = try await loginUseCase.execute(
                request: AccountLoginUseCaseRequest(
                    email: email,
                    password: password
                )
            )
            if isStoreLoginInformation {
                _ = setStoreLoginAccountInLocalUseCase.setStoreData(
                    request: SetStoreLoginAccountInLocalUseCaseRequest(
                        email: email,
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
                    errorDialogMessage = "メールアドレスまたはパスワードが間違っています。"
                
            case .userDisabled:
                errorDialogMessage = "このアカウントからのアクセスは禁止されています。"
            
            case .tooManyRequests:
                errorDialogMessage = "大量のアクセスが検知されました。時間を置いてから再度お試しください。"
                
            default:
                errorDialogMessage = "ネットワーク回線状況をお確かめください"
            }
            await MainActor.run {
                isShowErrorDialog = true
            }
        }
    }
}

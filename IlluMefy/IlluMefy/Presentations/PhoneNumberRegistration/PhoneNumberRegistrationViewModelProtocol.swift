//
//  PhoneNumberRegistrationViewModelProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/14.
//

import Combine

protocol PhoneNumberRegistrationViewModelProtocol: ObservableObject {
    // UseCases
    var setStoreLoginAccountInLocalUseCase: any SetStoreLoginAccountInLocalUseCaseProtocol { get set }
    var sendPhoneVerificationUseCase: any SendPhoneVerificationUseCaseProtocol { get set }
    
    // Published properties
    var isShowErrorDialog: Bool { get set }
    var isShowNotificationDialog: Bool { get set }
    var errorDialogMessage: String { get set }
    var notificationDialogMessage: String { get set }
    var phoneNumber: String { get set }
    var verificationID: String? { get set }
    
    // Methods
    func sendVerificationCode() async
}

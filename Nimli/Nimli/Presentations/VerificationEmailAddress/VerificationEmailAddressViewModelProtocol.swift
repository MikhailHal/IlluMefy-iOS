//
//  VerificationEmailAddressViewModelProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//

protocol VerificationEmailAddressViewModelProtocol: ViewModelProtocol {
    var verificationEmailAddressUseCase: any VerificationEmailAddressUseCaseProtocol { get set }
    func sendVerificationEmailLink() async -> (title: String, message: String)
}

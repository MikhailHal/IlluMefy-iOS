//
//  VerificationEmailAddressUseCaseProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//

import FirebaseAuth
protocol VerificationEmailAddressUseCaseProtocol: UseCaseWithParametesProtocol where Request == User? {
    var verificationEmailAddressRepository: any VerificationEmailAddressRepositoryProtocol { get set }
}

//
//  VerificationEmailAddressUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/25.
//

import FirebaseAuth

protocol VerificationEmailAddressUseCaseProtocol: UseCaseWithParametersSyncProtocol where Request == User? {
    var verificationEmailAddressRepository: any VerificationEmailAddressRepositoryProtocol { get }
}

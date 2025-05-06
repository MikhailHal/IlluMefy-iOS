//
//  ViewModelProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/03.
//

import Combine

protocol ViewModelProtocol: ObservableObject {
    var isShowErrorDialog: Bool { get set }
    var errorDialogMessage: String { get set }
    var isShowNotificationDialog: Bool { get set }
    var notificationDialogMessage: String { get set }
}

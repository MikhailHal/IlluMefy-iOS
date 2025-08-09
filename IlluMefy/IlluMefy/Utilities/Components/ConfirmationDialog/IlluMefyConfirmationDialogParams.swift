//
//  IlluMefyConfirmationDialogParams.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/09.
//

struct IlluMefyConfirmationDialogParams {
    let title: String
    let message: String
    let onClickOk: () -> Void
    let onClickCancel: () -> Void
}

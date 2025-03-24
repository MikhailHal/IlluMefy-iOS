//
//  NimliLoadingDialog.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

///
/// This was created for commonalizing the indicator.
///   - Parameters:
///     - isLoading: whether it is currently loading
///     - message: the string that we want to display to under of the indicator
struct NimliLoadingDialog: View {
    var isLoading: Bool
    var message: String?
    var body: some View {
        ZStack {
            if isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                VStack {
                    LoadingIndicator(
                        animation: .fiveLinesPulse,
                        color: Color.indicator,
                        size: .medium,
                        speed: .normal
                    )
                    if let message = message {
                        Text(message)
                            .foregroundColor(.white)
                            .padding(.top, 8)
                    }
                }
            }
        }
    }
}

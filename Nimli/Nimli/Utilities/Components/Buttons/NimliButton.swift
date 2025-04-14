//
//  NimliButton.swift
//  Nimli
//
//  Created by Haruto K. on 2025/02/25.
//

import SwiftUI

/*
 This was created for commonalizing button.
 */
struct NimliButton: View {
    var text: String
    var isEnabled: Bool
    var onClick: () -> Void
    var leadingIcon: AnyView?
    var endIcon: AnyView?

    var body: some View {
        Button(action: onClick) {
            HStack {
                if let icon = leadingIcon {
                    icon.foregroundColor(
                        isEnabled ? .imageForegroundOnButtonPositive : .imageForegroundOnButtonNegative)
                }
                Text(text)
                    .foregroundColor(isEnabled ? .buttonForegroundPositive : .buttonForegroundNegative)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(isEnabled ?
                        Color.buttonBackgroundPositive : Color.buttonBackgroundNegative
            )
        }
        .disabled(!isEnabled)
        .cornerRadius(10)
        .shadow(
            color: isEnabled ? .buttonBackgroundPositive.opacity(0.3) : Color.clear,
            radius: 5, x: 0, y: 2
        )
        .padding(.top, 10)
    }
}

struct NimliButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            NimliButton(
                text: "ログインする",
                isEnabled: true) {
                print("")
            }
            NimliButton(
                text: "ログインする",
                isEnabled: false) {
                print("")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

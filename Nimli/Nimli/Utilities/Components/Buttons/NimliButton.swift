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
                    icon
                }
                Text(text)
                    .foregroundColor(Color.buttonForegroundPositive)
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(isEnabled ?
                        Color.buttonBackgroundPositive : Color.buttonBackgroundNegative
            )
        }
        .disabled(!isEnabled)
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
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

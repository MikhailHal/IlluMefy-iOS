//
//  NimliPlainTextField.swift
//  Nimli
//
//  Created by Haruto K. on 2025/02/25.
//

import SwiftUI

/*
 This was created for commonalizing button.
 */
struct NimliButton: View {
    var eventType: NimliButtonsOption.EventType
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
            .background(eventType == NimliButtonsOption.EventType.positive ?
                        Color.buttonBackgroundPositive : Color.black
            )
        }
        .disabled(!isEnabled)
    }
}

struct NimliButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            // Empty state preview
            NimliButton(
                eventType: NimliButtonsOption.EventType.positive,
                text: "ログインする",
                isEnabled: true) {
                print("")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

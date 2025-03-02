//
//  PenculaPlainTextField.swift
//  Pencula
//
//  Created by Haruto K. on 2025/02/25.
//

import SwiftUI

/*
 This was created for commonalizing button.
 */
struct PenculaButton: View {
    var eventType: PenculaButtonsOption.EventType
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
            .background(eventType == PenculaButtonsOption.EventType.positive ?
                        Color.buttonBackgroundPositive : Color.black
            )
        }
        .disabled(!isEnabled)
    }
}

struct PenculaButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            // Empty state preview
            PenculaButton(
                eventType: PenculaButtonsOption.EventType.positive,
                text: "ログインする",
                isEnabled: true) {
                print("")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

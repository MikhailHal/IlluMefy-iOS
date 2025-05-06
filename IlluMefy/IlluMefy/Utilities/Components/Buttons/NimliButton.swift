//
//  IlluMefyButton.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/02/25.
//

import SwiftUI

/*
 This was created for commonalizing button.
 */
struct IlluMefyButton: View {
    @State private var ripplePosition: CGPoint = .zero
    @State private var rippleSize: CGFloat = 0
    @State private var rippleOpacity: Double = 0
    private let action: () -> Void
    private let title: String
    private let isEnabled: Bool
    init(title: String, isEnabled: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    ZStack {
                        if isEnabled {
                            Color("Button/BackgroundForEnabled")
                        } else {
                            Color("Button/BackgroundForDisabled")
                        }
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .scaleEffect(rippleSize)
                            .position(ripplePosition)
                            .opacity(rippleOpacity)
                    }
                )
                .foregroundColor(
                    isEnabled ? Color("Button/ForegroundForEnabled") : Color("Button/ForegroundForDisabled"))
                .cornerRadius(8)
                .clipped()
        })
        .simultaneousGesture(
            SpatialTapGesture()
                .onEnded { value in
                    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                    ripplePosition = value.location
                    withAnimation(.easeOut(duration: 0.15)) {
                        rippleOpacity = 0.4
                        rippleSize = 1.1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation(.easeOut(duration: 0.75)) {
                            rippleSize = 12.0
                            rippleOpacity = 0
                        }
                    }
                    feedbackGenerator.prepare()
                    feedbackGenerator.impactOccurred(intensity: 0.5)
                }
        )
        .disabled(!isEnabled)
    }
}

struct IlluMefyButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            IlluMefyButton(
                title: "テスト",
                isEnabled: true, action: {
                    print("")
                }
            )
            IlluMefyButton(
                title: "テスト",
                isEnabled: false, action: {
                    print("")
                }
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

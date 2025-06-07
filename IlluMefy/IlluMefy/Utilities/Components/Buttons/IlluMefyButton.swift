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
    // MARK: - Constants
    private enum Constants {
        static let buttonHeight: CGFloat = Size.buttonHeight
        static let cornerRadius: CGFloat = CornerRadius.button
        static let rippleInitialScale: CGFloat = Effects.rippleInitialScale
        static let rippleFinalScale: CGFloat = Effects.rippleFinalScale
        static let rippleInitialOpacity: Double = Opacity.rippleInitial
        static let rippleColorOpacity: Double = Opacity.rippleColor
        static let rippleInitialDuration: Double = AnimationDuration.rippleInitial
        static let rippleFinalDuration: Double = AnimationDuration.rippleFinal
        static let rippleDelay: Double = AnimationParameters.delayShort
        static let feedbackIntensity: CGFloat = Effects.feedbackIntensity
    }
    
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
                .frame(height: Constants.buttonHeight)
                .background(
                    ZStack {
                        if isEnabled {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor,
                                    Asset.Color.Button.buttonBackgroundGradationEnd.swiftUIColor
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Asset.Color.Button.buttonBackgroundDisable.swiftUIColor
                        }
                        Circle()
                            .fill(Color.white.opacity(Constants.rippleColorOpacity))
                            .scaleEffect(rippleSize)
                            .position(ripplePosition)
                            .opacity(rippleOpacity)
                    }
                )
                .foregroundColor(
                    isEnabled ?
                    Asset.Color.Button.buttonForeground.swiftUIColor
                    : Asset.Color.Button.buttonForegroundForDisabled.swiftUIColor)
                .cornerRadius(Constants.cornerRadius)
                .clipped()
        })
        .simultaneousGesture(
            SpatialTapGesture()
                .onEnded { value in
                    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                    ripplePosition = value.location
                    withAnimation(.easeOut(duration: Constants.rippleInitialDuration)) {
                        rippleOpacity = Constants.rippleInitialOpacity
                        rippleSize = Constants.rippleInitialScale
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.rippleDelay) {
                        withAnimation(.easeOut(duration: Constants.rippleFinalDuration)) {
                            rippleSize = Constants.rippleFinalScale
                            rippleOpacity = 0
                        }
                    }
                    feedbackGenerator.prepare()
                    feedbackGenerator.impactOccurred(intensity: Constants.feedbackIntensity)
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

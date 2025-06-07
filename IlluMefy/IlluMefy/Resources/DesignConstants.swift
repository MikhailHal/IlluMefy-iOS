//
//  DesignConstants.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/07.
//

import CoreGraphics

// MARK: - Opacity
enum Opacity {
    // Background overlays
    static let backgroundOverlay: Double = 0.4
    
    // Text and content
    static let primaryText: Double = 1.0
    static let secondaryText: Double = 0.85
    static let tertiaryText: Double = 0.65
    static let disabledText: Double = 0.5
    static let placeholder: Double = 0.6
    
    // Effects
    static let shadow: Double = 0.05
    static let buttonShadow: Double = 0.3
    static let glow: Double = 0.3
    static let particle: Double = 0.3
    static let rippleInitial: Double = 0.4
    static let rippleColor: Double = 0.3
    static let pulseEffect: Double = 0.5
    
    // Gradient
    static let gradientStart: Double = 0.05
    static let gradientEnd: Double = 0.45
}

// MARK: - Corner Radius
enum CornerRadius {
    static let small: CGFloat = 4
    static let medium: CGFloat = 8
    static let large: CGFloat = 12
    
    // Component specific
    static let textField: CGFloat = 8
    static let button: CGFloat = 8
    static let card: CGFloat = 8
    static let checkbox: CGFloat = 4
}

// MARK: - Size
enum Size {
    // Icon sizes
    static let iconSmall: CGFloat = 20
    static let iconMedium: CGFloat = 24
    static let iconLarge: CGFloat = 100
    static let iconGlow: CGFloat = 120
    
    // Component sizes
    static let buttonHeight: CGFloat = 52
    static let textFieldPaddingVertical: CGFloat = 12
    static let textFieldPaddingHorizontal: CGFloat = 20
    static let checkboxSize: CGFloat = 20
    static let tapAreaMinimum: CGFloat = 44
    
    // Particle sizes
    static let particleMin: CGFloat = 4
    static let particleMax: CGFloat = 8
}

// MARK: - Border Width
enum BorderWidth {
    static let thin: CGFloat = 0.5
    static let medium: CGFloat = 1.0
    static let thick: CGFloat = 1.5
    static let extraThick: CGFloat = 2.0
    
    // Component specific
    static let textFieldDefault: CGFloat = 0.5
    static let textFieldFocused: CGFloat = 1.5
    static let checkbox: CGFloat = 1.5
}

// MARK: - Animation Duration
enum AnimationDuration {
    static let instant: Double = 0.15
    static let fast: Double = 0.3
    static let normal: Double = 0.5
    static let medium: Double = 0.6
    static let slow: Double = 0.8
    static let verySlow: Double = 1.5
    
    // Effect specific
    static let gradient: Double = 8.0
    static let glow: Double = 2.0
    static let rippleInitial: Double = 0.15
    static let rippleFinal: Double = 0.75
    static let particleMin: Double = 15
    static let particleMax: Double = 25
}

// MARK: - Animation Parameters
enum AnimationParameters {
    static let springResponse: Double = 0.3
    static let springResponseMedium: Double = 0.4
    static let springResponseSlow: Double = 0.8
    static let springDamping: Double = 0.6
    static let springDampingMedium: Double = 0.7
    static let springDampingHigh: Double = 0.8
    
    // Delays
    static let delayShort: Double = 0.05
    static let delayMedium: Double = 0.3
    static let delayLong: Double = 0.5
    static let delayExtraLong: Double = 0.7
    static let delayVeryLong: Double = 0.9
    static let particleMaxDelay: Double = 5.0
    static let autoFocusDelay: Double = 0.5
}

// MARK: - Shadow
enum Shadow {
    static let radiusSmall: CGFloat = 8
    static let radiusMedium: CGFloat = 10
    static let radiusLarge: CGFloat = 15
    static let radiusXLarge: CGFloat = 20
    
    static let offsetYSmall: CGFloat = 2
    static let offsetYMedium: CGFloat = 5
    static let offsetYLarge: CGFloat = 8
    static let offsetYXLarge: CGFloat = 10
}

// MARK: - Effects
enum Effects {
    static let blurRadius: CGFloat = 10
    static let blurRadiusLarge: CGFloat = 20
    static let glowScale: CGFloat = 1.1
    static let focusScale: CGFloat = 1.02
    static let rippleInitialScale: CGFloat = 1.1
    static let rippleFinalScale: CGFloat = 12.0
    static let rotation360: CGFloat = 360
    static let perspective: CGFloat = 0.5
    static let initialScale: CGFloat = 0.5
    static let feedbackIntensity: CGFloat = 0.5
}

// MARK: - Typography
enum Typography {
    static let titleLarge: CGFloat = 36
    static let titleMedium: CGFloat = 32
    static let bodyRegular: CGFloat = 16
    static let checkmark: CGFloat = 14
}

// MARK: - Layout
enum Layout {
    static let particleCount: Int = 15
    static let particleOffsetY: CGFloat = 20
    static let textFieldTrailingPadding: CGFloat = 16
    static let formOffset: CGFloat = -50
    static let titleOffsetY: CGFloat = 20
    static let subtitleOffsetY: CGFloat = 10
    static let pulseFrameHeight: CGFloat = 56
    static let gradientStartRadius: CGFloat = 20
    static let gradientEndRadius: CGFloat = 60
    static let verificationCodeMaxLength: Int = 6
    static let buttonFrameHeight: CGFloat = 56
    static let descriptionSpacing: CGFloat = 6
}

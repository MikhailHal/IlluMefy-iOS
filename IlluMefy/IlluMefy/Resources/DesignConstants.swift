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
    
    // Light overlays
    static let overlayLight: Double = 0.1
    static let overlayMedium: Double = 0.2
    static let overlayHeavy: Double = 0.7
    static let elementFocused: Double = 0.9
    
    // Gradient
    static let gradientStart: Double = 0.05
    static let gradientEnd: Double = 0.45
}

// MARK: - Corner Radius
enum CornerRadius {
    static let small: CGFloat = 4
    static let medium: CGFloat = 8
    static let large: CGFloat = 12
    static let extraLarge: CGFloat = 16
    static let round: CGFloat = 20
    
    // Component specific
    static let textField: CGFloat = 8
    static let button: CGFloat = 8
    static let card: CGFloat = 8
    static let checkbox: CGFloat = 4
    static let tile: CGFloat = 16
    static let tag: CGFloat = 20
}

// MARK: - Size
enum Size {
    // Icon sizes
    static let iconSmall: CGFloat = 20
    static let iconSmallMedium: CGFloat = 28
    static let iconMedium: CGFloat = 24
    static let iconLarge: CGFloat = 100
    static let iconGlow: CGFloat = 120
    
    // Small specific sizes
    static let smallImageSize: CGFloat = 50
    static let smallIconSize: CGFloat = 16
    
    // Component sizes
    static let buttonHeight: CGFloat = 52
    static let textFieldPaddingVertical: CGFloat = 12
    static let textFieldPaddingHorizontal: CGFloat = 20
    static let checkboxSize: CGFloat = 20
    static let tapAreaMinimum: CGFloat = 44
    
    // Creator tile sizes
    static let creatorTileWidth: CGFloat = 160
    static let creatorTileHeight: CGFloat = 220
    static let creatorImageSize: CGFloat = 120
    static let similarCreatorImageSize: CGFloat = 80
    static let similarCreatorCardWidth: CGFloat = 100
    
    // Creator card sizes (Home screen horizontal scroll)
    static let creatorCardWidth: CGFloat = 150
    static let creatorCardHeight: CGFloat = 200
    
    // Platform icon overlay
    static let platformOverlayWidth: CGFloat = 50
    static let platformOverlayHeight: CGFloat = 35
    static let platformIconSize: CGFloat = 25
    
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
    
    // Interaction animations
    static let buttonPress: Double = 0.1
    static let heartBeat: Double = 0.2
    static let tagPulse: Double = 2.0
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
    
    // Press effects
    static let scalePressed: CGFloat = 0.95
    static let scalePressedLight: CGFloat = 0.98
    static let scaleHeart: CGFloat = 1.1
    static let scaleIcon: CGFloat = 1.5
    
    // Animation states
    static let visibleOpacity: CGFloat = 1.0
    static let dimmedOpacity: CGFloat = 0.4
    static let scaledDown: CGFloat = 0.8
}

// MARK: - Typography
enum Typography {
    static let titleExtraLarge: CGFloat = 60
    static let titleLarge: CGFloat = 36
    static let titleMedium: CGFloat = 32
    static let iconMedium: CGFloat = 20
    static let bodyRegular: CGFloat = 16
    static let checkmark: CGFloat = 14
    static let captionSmall: CGFloat = 12
    static let caption2: CGFloat = 11
    static let captionExtraSmall: CGFloat = 10
    static let captionMini: CGFloat = 9
    static let systemSmall: CGFloat = 8
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
    
    // Creator tile specific
    static let platformIndicatorBottomOffset: CGFloat = 45
    static let homeGradientStartRadius: CGFloat = 50
    static let homeGradientEndRadius: CGFloat = 250
    
    // Business logic constants
    static let popularityThreshold: Int = 500
}

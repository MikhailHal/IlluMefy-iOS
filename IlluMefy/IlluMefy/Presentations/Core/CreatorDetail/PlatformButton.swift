//
//  CreatorDetailComponents.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/13.
//

import SwiftUI
import UIKit

// MARK: - Supporting Views

struct PlatformButton: View {
    let platform: Platform
    let url: String
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }, label: {
            HStack(spacing: 12) {
                // Platform icon
                if platform == .youtube {
                    Image(systemName: platform.icon)
                        .font(.system(size: Typography.iconMedium))
                        .foregroundColor(.red)
                } else {
                    Image(platform.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Size.iconSmall, height: Size.iconSmall)
                }
                
                // Platform name
                Text(platformDisplayName(platform))
                    .font(.system(size: Typography.captionSmall, weight: .medium))
                    .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                
                Spacer()
                
                // External link icon
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, Spacing.relatedComponentDivider)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(.primary.opacity(Opacity.overlayMedium), lineWidth: BorderWidth.medium)
            )
            .scaleEffect(isPressed ? Effects.scalePressed : Effects.visibleOpacity)
            .animation(.easeInOut(duration: AnimationDuration.buttonPress), value: isPressed)
        })
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(.easeInOut(duration: AnimationDuration.buttonPress)) {
                isPressed = pressing
            }
        } perform: {}
    }
    
    private func platformDisplayName(_ platform: Platform) -> String {
        switch platform {
        case .youtube:
            return L10n.Platform.youtube
        case .twitch:
            return L10n.Platform.twitch
        case .niconico:
            return L10n.Platform.niconico
        case .x:
            return L10n.Platform.x
        case .instagram:
            return L10n.Platform.instagram
        case .tiktok:
            return L10n.Platform.tiktok
        case .discord:
            return L10n.Platform.discord
        }
    }
}

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

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.primary.opacity(Opacity.overlayHeavy))
            
            Text(value)
                .font(.title2)
                .bold()
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(.primary.opacity(Opacity.overlayLight), lineWidth: BorderWidth.medium)
        )
    }
}

// MARK: - TagChip Component

struct TagChip: View {
    let tagName: String
    let isEditing: Bool
    let onDelete: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 4) {
            Text("#\(tagName)")
                .font(.caption)
            
            if isEditing {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    onDelete()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: Typography.captionSmall))
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal, Spacing.relatedComponentDivider)
        .padding(.vertical, Spacing.smallMedium)
        .background(
            Capsule()
                .fill(isEditing ? Color.red.opacity(Opacity.overlayLight) : Color(.systemBackground).opacity(Opacity.secondaryText))
        )
        .overlay(
            Capsule()
                .stroke(isEditing ? .red.opacity(Opacity.glow) : .primary.opacity(Opacity.overlayMedium), lineWidth: BorderWidth.medium)
        )
        .scaleEffect(isPressed ? Effects.scalePressed : Effects.visibleOpacity)
        .animation(.easeInOut(duration: AnimationDuration.buttonPress), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(.easeInOut(duration: AnimationDuration.buttonPress)) {
                isPressed = pressing
            }
        } perform: {}
    }
}

// MARK: - InfoCorrectionButton Component

struct InfoCorrectionButton: View {
    let title: String
    let description: String
    let icon: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            action()
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: Typography.iconMedium))
                    .foregroundColor(.orange)
                    .frame(width: Size.iconSmallMedium)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: Typography.bodyRegular, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.system(size: Typography.captionSmall))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
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
                    .stroke(.primary.opacity(Opacity.overlayLight), lineWidth: BorderWidth.medium)
            )
            .scaleEffect(isPressed ? Effects.scalePressedLight : Effects.visibleOpacity)
            .animation(.easeInOut(duration: AnimationDuration.buttonPress), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(.easeInOut(duration: AnimationDuration.buttonPress)) {
                isPressed = pressing
            }
        } perform: {}
    }
}

// MARK: - SimilarCreatorCard Component

struct SimilarCreatorCard: View {
    let creator: Creator
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Creator image
            AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(Opacity.glow))
                    .overlay(
                        ProgressView()
                    )
            }
            .frame(width: Size.similarCreatorImageSize, height: Size.similarCreatorImageSize)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.white.opacity(Opacity.glow), lineWidth: BorderWidth.extraThick)
            )
            
            // Creator info
            VStack(spacing: 4) {
                Text(creator.name)
                    .font(.caption)
                    .bold()
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 4) {
                    Image(systemName: "eye.fill")
                        .font(.system(size: Typography.systemSmall))
                        .foregroundColor(.secondary)
                    Text(formatViewCount(creator.viewCount))
                        .font(.system(size: Typography.systemSmall))
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: Size.similarCreatorCardWidth)
        .padding(.vertical, Spacing.componentGrouping)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(.primary.opacity(Opacity.overlayLight), lineWidth: BorderWidth.medium)
        )
        .scaleEffect(isPressed ? Effects.scalePressed : Effects.visibleOpacity)
        .animation(.easeInOut(duration: AnimationDuration.buttonPress), value: isPressed)
        .shadow(
            color: isPressed ? .clear : .black.opacity(Opacity.overlayLight),
            radius: isPressed ? 0 : 4,
            x: 0,
            y: isPressed ? 0 : 2
        )
        .onTapGesture {
            // 触覚フィードバック
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            onTap()
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(.easeInOut(duration: AnimationDuration.buttonPress)) {
                isPressed = pressing
            }
        } perform: {}
    }
    
    private func formatViewCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000)
        } else {
            return "\(count)"
        }
    }
}

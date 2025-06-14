//
//  TagTile.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/11.
//

import SwiftUI

struct TagTile: View {
    let tag: Tag
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Tag name with popularity pulse
            Text("#\(tag.displayName)")
                .font(.system(size: Typography.bodyRegular, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
                .scaleEffect(isPopular ? (isAnimating ? 1.05 : 1.0) : 1.0)
                .animation(.easeInOut(duration: AnimationDuration.tagPulse).repeatForever(autoreverses: true), value: isAnimating)
            
            // Click count with number animation
            HStack(spacing: 4) {
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: Typography.captionExtraSmall))
                    .foregroundColor(.white.opacity(Opacity.secondaryText))
                
                Text(formatClickCount(tag.clickedCount))
                    .font(.system(size: Typography.captionSmall, weight: .medium))
                    .foregroundColor(.white.opacity(Opacity.elementFocused))
                    .contentTransition(.numericText())
            }
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.relatedComponentDivider)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.tag)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.tag)
                .stroke(.white.opacity(Opacity.glow), lineWidth: BorderWidth.medium)
        )
        .shadow(color: .black.opacity(Opacity.overlayMedium), radius: Shadow.radiusSmall, x: 0, y: Shadow.offsetYSmall)
        .onAppear {
            if isPopular {
                isAnimating = true
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var isPopular: Bool {
        tag.clickedCount > Layout.popularityThreshold // 人気閾値
    }
    
    private var gradientColors: [Color] {
        if isPopular {
            return [.orange, .red] // 人気タグは暖色
        } else {
            return [.blue.opacity(Opacity.secondaryText), .purple.opacity(Opacity.secondaryText)] // 通常は寒色
        }
    }
    
    // MARK: - Helper Functions
    
    private func formatClickCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000)
        } else {
            return "\(count)"
        }
    }
}

#Preview {
    HStack {
        TagTile(tag: Tag(
            id: "1",
            displayName: "FPS",
            tagName: "fps",
            clickedCount: 1200,
            createdAt: Date(),
            updatedAt: Date(),
            parentTagId: nil,
            childTagIds: []
        ))
        
        TagTile(tag: Tag(
            id: "2",
            displayName: "VTuber",
            tagName: "vtuber",
            clickedCount: 890,
            createdAt: Date(),
            updatedAt: Date(),
            parentTagId: nil,
            childTagIds: []
        ))
        
        TagTile(tag: Tag(
            id: "3",
            displayName: "Minecraft",
            tagName: "minecraft",
            clickedCount: 250,
            createdAt: Date(),
            updatedAt: Date(),
            parentTagId: nil,
            childTagIds: []
        ))
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}

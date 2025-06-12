//
//  CreatorDetailView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/13.
//

import SwiftUI

struct CreatorDetailView: View {
    let creator: Creator
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                // Header section with close button
                headerSection
                
                // Creator profile section
                creatorProfileSection
                
                // Platform buttons section
                platformButtonsSection
                
                // Tags section
                tagsSection
                
                // Tag registration section
                tagRegistrationSection
                
                // Information correction section
                informationCorrectionSection
                
                // Stats section
                statsSection
            }
            .padding(Spacing.screenEdgePadding)
        }
        .background(Asset.Color.Application.Background.background.swiftUIColor)
        .navigationBarHidden(true)
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        HStack {
            Spacer()
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.primary.opacity(0.6))
            }
        }
    }
    
    private var creatorProfileSection: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            // Creator image
            AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                    )
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Creator name
            Text(creator.name)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            // Main platform indicator
            HStack {
                let (platform, _) = creator.mainPlatform()
                if platform == .youtube {
                    Image(systemName: platform.icon)
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                } else {
                    Image(platform.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                }
                Text("メインプラットフォーム")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var platformButtonsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text("SNSリンク")
                .font(.headline)
                .bold()
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.relatedComponentDivider) {
                ForEach(Array(creator.platform.keys), id: \.self) { platform in
                    if let url = creator.platform[platform] {
                        PlatformButton(platform: platform, url: url)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text("関連タグ")
                .font(.headline)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(creator.relatedTag, id: \.self) { tag in
                        TagChip(tagName: tag, isEditing: false) {
                            // タグ削除アクション
                        }
                    }
                }
                .padding(.trailing, Spacing.screenEdgePadding)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var tagRegistrationSection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text("タグ申請")
                .font(.headline)
                .bold()
            
            Text("このクリエイターに新しいタグを提案したり、不適切なタグを報告できます")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: Spacing.relatedComponentDivider) {
                Button(action: {
                    // タグ削除申請画面への遷移
                }, label: {
                    HStack {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 16))
                        Text("タグ削除申請")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.primary.opacity(0.2), lineWidth: 1)
                    )
                })
                
                Button(action: {
                    // タグ申請画面への遷移
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                        Text("タグ追加申請")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [
                                Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor,
                                Asset.Color.Button.buttonBackgroundGradationEnd.swiftUIColor
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                })
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var informationCorrectionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text("情報修正")
                .font(.headline)
                .bold()
            
            Text("クリエイター情報に間違いや古い情報がある場合は修正依頼を送信できます")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                InfoCorrectionButton(
                    title: "プロフィール情報の修正",
                    description: "名前、説明文、プロフィール画像など",
                    icon: "person.circle",
                    action: {
                        // プロフィール修正画面への遷移
                    }
                )
                
                InfoCorrectionButton(
                    title: "SNSリンクの修正",
                    description: "URL変更、アカウント削除など",
                    icon: "link.circle",
                    action: {
                        // SNSリンク修正画面への遷移
                    }
                )
                
                InfoCorrectionButton(
                    title: "活動状況の報告",
                    description: "引退、活動休止、復帰など",
                    icon: "exclamationmark.circle",
                    action: {
                        // 活動状況報告画面への遷移
                    }
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var statsSection: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text("統計情報")
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: Spacing.unrelatedComponentDivider) {
                StatCard(
                    title: "総視聴数",
                    value: formatViewCount(creator.viewCount),
                    icon: "eye.fill"
                )
                
                StatCard(
                    title: "SNSクリック",
                    value: formatViewCount(creator.socialLinkClickCount),
                    icon: "link"
                )
                
                StatCard(
                    title: "プラットフォーム",
                    value: "\(creator.platform.count)",
                    icon: "square.grid.2x2"
                )
            }
        }
    }
    
    // MARK: - Helper Functions
    
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

// MARK: - Supporting Views

struct PlatformButton: View {
    let platform: Platform
    let url: String
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack(spacing: 12) {
                // Platform icon
                if platform == .youtube {
                    Image(systemName: platform.icon)
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                } else {
                    Image(platform.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                
                // Platform name
                Text(platformDisplayName(platform))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                
                Spacer()
                
                // External link icon
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        } perform: {}
    }
    
    private func platformDisplayName(_ platform: Platform) -> String {
        switch platform {
        case .youtube:
            return "YouTube"
        case .twitch:
            return "Twitch"
        case .niconico:
            return "ニコニコ動画"
        case .x:
            return "X (Twitter)"
        case .instagram:
            return "Instagram"
        case .tiktok:
            return "TikTok"
        case .discord:
            return "Discord"
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
                .foregroundColor(.primary.opacity(0.7))
            
            Text(value)
                .font(.title2)
                .bold()
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.primary.opacity(0.1), lineWidth: 1)
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
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(isEditing ? Color.red.opacity(0.1) : Color(.systemBackground).opacity(0.8))
        )
        .overlay(
            Capsule()
                .stroke(isEditing ? .red.opacity(0.3) : .primary.opacity(0.2), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
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
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.orange)
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary.opacity(0.1), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        } perform: {}
    }
}

#Preview {
    CreatorDetailView(creator: Creator(
        id: "creator_001",
        name: "ゲーム実況者A",
        thumbnailUrl: "https://picsum.photos/200/200?random=1",
        viewCount: 5000,
        socialLinkClickCount: 1500,
        platformClickRatio: [
            .niconico: 0.6,
            .youtube: 0.3,
            .x: 0.1
        ],
        relatedTag: ["fps", "apex-legends", "valorant", "gaming", "gaming", "gaming", "gaming", "gaming"],
        description: "FPSゲームをメインに実況しています。毎日20時から配信！初心者から上級者まで楽しめるコンテンツを心がけています。",
        platform: [
            .niconico: "https://www.nicovideo.jp/user/12345678",
            .youtube: "https://youtube.com/@gameplayerA",
            .twitch: "https://twitch.tv/gameplayerA",
            .x: "https://twitter.com/gameplayerA",
            .instagram: "https://instagram.com/gameplayerA",
            .tiktok: "https://tiktok.com/@gameplayerA"
        ],
        createdAt: Date().addingTimeInterval(-86400 * 30),
        updatedAt: Date().addingTimeInterval(-3600),
        isActive: true
    ))
}

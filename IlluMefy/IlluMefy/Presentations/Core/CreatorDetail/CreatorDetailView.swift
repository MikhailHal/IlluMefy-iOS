//
//  CreatorDetailView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/13.
//

import SwiftUI
import UIKit
import WrappingHStack

struct CreatorDetailView: View {
    @State private var viewModel: CreatorDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: IlluMefyAppRouter
    @State private var isPresentedTagAddApplication = false
    @State private var showingTagDeleteConfirmation = false
    @State private var selectedTagForDeletion: String = ""
    @State private var showingTagApplicationSuccess = false
    
    init(creator: Creator) {
        let container = DependencyContainer.shared
        guard let viewModel = container.container.resolve(CreatorDetailViewModel.self, argument: creator) else {
            fatalError("Failed to resolve CreatorDetailViewModel for creatorId: \(creator.id)")
        }
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                // プロフィール
                creatorProfileSection(creator: viewModel.creator)
                
                // 詳細情報
                detailSection(creator: viewModel.creator)
                
                // 各種SNS
                platformButtonsSection(creator: viewModel.creator)
                
                // タグ
                if viewModel.isLoadingTags {
                    tagsSectionSkeleton()
                } else if !viewModel.tags.isEmpty {
                    tagsSection(tags: viewModel.tags)
                }
                
                // エラーメッセージがあれば表示
                if let errorMessage = viewModel.errorMessage {
                    errorBanner(message: errorMessage)
                }
            }
            .padding(Spacing.screenEdgePadding)
        }
        .background(Asset.Color.CreatorDetailCard.creatorDetailCardBackground.swiftUIColor)
        .overlay {
            if isPresentedTagAddApplication {
                IlluMefyTextInputDialog(
                    title: L10n.CreatorDetail.tagApplication,
                    message: "追加したいタグ名を入力してください",
                    placeholder: "タグ名",
                    onSubmit: { tagName in
                        Task {
                            await viewModel.submitTagAddApplication(tagName: tagName)
                            isPresentedTagAddApplication = false
                            hideKeyboard()
                            showingTagApplicationSuccess = true
                        }
                    },
                    onCancel: {
                        isPresentedTagAddApplication = false
                    }
                )
            }
        }
        .alert("申請完了", isPresented: $showingTagApplicationSuccess) {
            Button("OK") { }
        } message: {
            Text("タグの追加申請を受け付けました。\n審査後に反映されます。")
        }
    }
    
    // MARK: - View Components
    
    private func errorBanner(message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.orange)
            Text(message)
                .font(.caption)
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
            Spacer()
        }
        .padding(Spacing.relatedComponentDivider)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(Asset.Color.CreatorDetailCard.creatorDetailCardSectionBackground.swiftUIColor)
        )
    }
    private func creatorProfileSection(creator: Creator) -> some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Asset.Color.CreatorDetailCard.creatorDetailCardSectionBackground.swiftUIColor)
                    .shimmering()
            }
            .frame(width: Size.creatorImageSize, height: Size.creatorImageSize)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Asset.Color.CreatorDetailCard.creatorDetailCardBorder.swiftUIColor, Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: BorderWidth.extraThick + BorderWidth.thin
                    )
            )
            .shadow(
                color: Asset.Color.CreatorDetailCard.creatorDetailCardBorder.swiftUIColor.opacity(Opacity.overlayMedium),
                radius: Shadow.radiusMedium,
                x: 0,
                y: Shadow.offsetYMedium
            )
            
            Text(creator.name)
                .font(.system(size: Typography.titleLarge, weight: .bold))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardTitle.swiftUIColor)
                .multilineTextAlignment(.center)
            
            if viewModel.isLoadingFavoriteStauts {
                favoriteButtonSkeleton()
            } else {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                    impactFeedback.impactOccurred()
                    withAnimation(.easeInOut(duration: AnimationDuration.heartBeat)) {
                        viewModel.toggleFavorite()
                    }
                }, label: {
                    HStack(spacing: Spacing.componentGrouping) {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: Typography.bodyRegular))
                        Text(viewModel.isFavorite ? L10n.Favorite.favorited : L10n.Favorite.addToFavorite)
                            .font(.system(size: Typography.bodyRegular, weight: .medium))
                    }
                    .foregroundColor(
                        viewModel.isFavorite
                            ? .white
                            : Asset.Color.CreatorDetailCard.creatorDetailCardTitle.swiftUIColor
                    )
                    .padding(.horizontal, Spacing.medium)
                    .padding(.vertical, Spacing.componentGrouping)
                    .background(
                        Capsule()
                            .fill(
                                viewModel.isFavorite
                                ? Asset.Color.CreatorDetailCard.creatorDetailCardFavorite.swiftUIColor
                                    : Asset.Color.CreatorDetailCard.creatorDetailCardFavorite.swiftUIColor.opacity(0.15)
                            )
                    )
                    .overlay(
                        Capsule()
                            .stroke(
                                Asset.Color.WarningText.warningLabelForground.swiftUIColor,
                                lineWidth: viewModel.isFavorite ? 0 : 1
                            )
                    )
                    .scaleEffect(viewModel.isFavorite ? Effects.scaleHeart : Effects.visibleOpacity)
                    .animation(
                        .spring(
                            response: AnimationParameters.springResponse,
                            dampingFraction: AnimationParameters.springDamping
                        ),
                        value: viewModel.isFavorite
                    )
                })
            }
        }
    }
    
    private func detailSection(creator: Creator) -> some View {
        HStack(spacing: Spacing.unrelatedComponentDivider) {
            // 視聴回数
            VStack(spacing: Spacing.relatedComponentDivider) {
                Text(formatViewCount(creator.youtube?.numberOfViews ?? 0))
                    .font(.system(size: Typography.bodyRegular, weight: .bold))
                    .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
                Text(L10n.CreatorDetail.numberOfViews)
                    .multilineTextAlignment(.center)
                     .font(.system(size: Typography.bodyRegular, weight: .bold))
                     .foregroundColor(
                        Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor.opacity(0.6)
                     )
            }.frame(maxWidth: .infinity)
            
            // クリック数
            Divider()
                .frame(height: 50)
            
            // チャンネル登録者数
            VStack(spacing: Spacing.relatedComponentDivider) {
                Text(formatViewCount(viewModel.favoriteCount))
                    .font(.system(size: Typography.bodyRegular, weight: .bold))
                    .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
                Text(L10n.CreatorDetail.favoriteUsers)
                    .multilineTextAlignment(.center)
                     .font(.system(size: Typography.bodyRegular, weight: .bold))
                     .foregroundColor(
                        Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor.opacity(0.6)
                     )
            }.frame(maxWidth: .infinity)
        }
    }
    private func platformButtonsSection(creator: Creator) -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.snsLinks)
                .font(.system(size: Typography.titleMedium, weight: .bold))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
            
            if let channel = creator.youtube {
                PlatformButton(
                    icon: channel.platformIcon(),
                    url: channel.channelUrl()
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func tagsSection(tags: [Tag]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.relatedTags)
                .font(.system(size: Typography.titleMedium, weight: .bold))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
            
            Text(L10n.CreatorDetail.tagDeletionInstruction)
                .font(.system(size: Typography.captionSmall))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
            
            WrappingHStack(displayItems(from: tags), spacing: .constant(Spacing.componentGrouping)) { item in
                switch item {
                case .addButton:
                    IlluMefyAddTag {
                        isPresentedTagAddApplication = true
                    }
                        .padding(.vertical, Spacing.componentGrouping)
                case .tag(let tag):
                    IlluMefyFeaturedTag(
                        text: tag.displayName,
                        onTapped: { _ in
                            router.navigate(to: .search(tag: tag))
                        },
                        onLongPress: { tagText in
                            selectedTagForDeletion = tagText
                            showingTagDeleteConfirmation = true
                        },
                        isDeletable: true
                    )
                    .padding(.vertical, Spacing.componentGrouping)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // タグ表示用のアイテム型定義
    private enum TagDisplayItem: Identifiable {
        case addButton
        case tag(Tag)
        
        var id: String {
            switch self {
            case .addButton:
                return "add_button"
            case .tag(let tag):
                return tag.id
            }
        }
    }
    
    // タグ配列から表示用アイテム配列を生成
    private func displayItems(from tags: [Tag]) -> [TagDisplayItem] {
        [.addButton] + tags.map { .tag($0) }
    }
    
    private func similarCreatorsSection(similarCreators: [Creator]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.similarCreators)
                .font(.system(size: Typography.titleMedium, weight: .bold))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(L10n.CreatorDetail.similarCreatorsDescription)
                .font(.system(size: Typography.bodyRegular))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.componentGrouping) {
                    ForEach(similarCreators) { similarCreator in
                        CreatorTile(creator: similarCreator)
                    }
                }
                .padding(.trailing, Spacing.screenEdgePadding)
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
    
    // MARK: - Skeleton Views
    
    private func favoriteButtonSkeleton() -> some View {
        Capsule()
            .fill(Color.gray.opacity(Opacity.glow))
            .frame(width: 180, height: 40)
            .shimmering()
    }
    
    private func creatorProfileSectionSkeleton() -> some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Circle()
                .fill(Color.gray.opacity(Opacity.glow))
                .frame(width: Size.creatorImageSize, height: Size.creatorImageSize)
                .shimmering()
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(Opacity.glow))
                .frame(width: 150, height: 28)
                .shimmering()
            
            RoundedRectangle(cornerRadius: CornerRadius.extraLarge)
                .fill(Color.gray.opacity(Opacity.glow))
                .frame(width: 180, height: 40)
                .shimmering()
            
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(Opacity.glow))
                    .frame(width: 100, height: 16)
                    .shimmering()
            }
        }
    }
    
    private func detailSectionSkeleton() -> some View {
        HStack(spacing: Spacing.unrelatedComponentDivider) {
            ForEach(0..<3, id: \.self) { _ in
                VStack(spacing: Spacing.relatedComponentDivider) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(Opacity.glow))
                        .frame(width: 60, height: 20)
                        .shimmering()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(Opacity.glow))
                        .frame(width: 80, height: 32)
                        .shimmering()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func platformButtonsSectionSkeleton() -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(Opacity.glow))
                .frame(width: 120, height: 20)
                .shimmering()
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.relatedComponentDivider) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: CornerRadius.large)
                        .fill(Color.gray.opacity(Opacity.glow))
                        .frame(height: 50)
                        .shimmering()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func tagsSectionSkeleton() -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.relatedTags)
                .font(.system(size: Typography.titleMedium, weight: .bold))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
            
            Text(L10n.CreatorDetail.tagDeletionInstruction)
                .font(.system(size: Typography.captionSmall))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
            WrappingHStack(0..<50, spacing: .constant(Spacing.relatedComponentDivider)) { _ in
                RoundedRectangle(cornerRadius: CornerRadius.tag)
                    .fill(Color.gray.opacity(Opacity.glow))
                    .frame(width: 100, height: 25)
                    .shimmering()
                    .padding(.vertical, 4)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func similarCreatorsSectionSkeleton() -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(Opacity.glow))
                .frame(width: 140, height: 20)
                .shimmering()
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(Opacity.glow))
                .frame(width: 200, height: 16)
                .shimmering()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.componentGrouping) {
                    ForEach(0..<3, id: \.self) { _ in
                        CreatorTile(creator: nil)
                    }
                }
                .padding(.trailing, Spacing.screenEdgePadding)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview("正常表示") {
    NavigationStack {
        let mockCreator = Creator(
            id: "creator_001",
            name: "ゲーム実況者A",
            thumbnailUrl: "https://picsum.photos/200/200?random=1",
            socialLinkClickCount: 1500,
            tag: ["tag_007", "tag_011"],
            description: "FPSゲームをメインに実況しています。毎日20時から配信！",
            youtube: nil,
            createdAt: Date().addingTimeInterval(-86400 * 30),
            updatedAt: Date().addingTimeInterval(-3600),
            favoriteCount: 100
        )
        
        CreatorDetailView(creator: mockCreator)
    }
}

#Preview("ローディング中") {
    struct MockLoadingView: View {
        @State private var viewModel = MockCreatorDetailViewModel()
        
        var body: some View {
            if viewModel.isLoadingTags {
                Text(L10n.Common.loading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Asset.Color.CreatorDetailCard.creatorDetailCardBackground.swiftUIColor)
            } else {
                Text(L10n.Common.loadingState)
            }
        }
    }
    
    return MockLoadingView()
}

#Preview("エラー表示") {
    struct MockErrorView: View {
        @State private var viewModel = MockCreatorDetailViewModel.mockError()
        
        var body: some View {
            if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: Typography.titleExtraLarge))
                        .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardFavoriteActive.swiftUIColor)
                    Text("エラー")
                        .font(.title2)
                        .bold()
                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
                        .multilineTextAlignment(.center)
                    Button(L10n.Common.retry) {
                        // Dummy action
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Asset.Color.CreatorDetailCard.creatorDetailCardBackground.swiftUIColor)
            } else {
                Text(L10n.Common.errorState)
            }
        }
    }
    
    return MockErrorView()
}

#Preview("ナビゲーションテスト") {
    struct NavigationTestView: View {
        // State variables removed for preview
        
        var body: some View {
            NavigationStack {
                VStack {
                    Text(L10n.Common.navigationTest)
                        .font(.title)
                    
                    Button(L10n.Common.openCreatorDetail) {
                        // Navigation would be handled by router
                    }
                    .buttonStyle(.borderedProminent)
                }
                // Navigation via router would be used in real app
            }
        }
    }
    
    return NavigationTestView()
}

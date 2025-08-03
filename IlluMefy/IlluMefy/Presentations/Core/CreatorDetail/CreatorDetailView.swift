//
//  CreatorDetailView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/13.
//

import SwiftUI
import UIKit

struct CreatorDetailView: View {
    @StateObject private var viewModel: CreatorDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var currentCreatorId: String
    @EnvironmentObject private var router: IlluMefyAppRouter
    @State private var showingTagApplication = false
    @State private var tagApplicationType: TagApplicationRequest.ApplicationType = .add
    @State private var showingTagApplicationTypeSelection = false
    @State private var showingProfileCorrection = false
    @State private var showingTagDeleteConfirmation = false
    @State private var selectedTagForDeletion: String = ""
    
    init(creatorId: String) {
        let container = DependencyContainer.shared
        guard let viewModel = container.container.resolve(CreatorDetailViewModel.self, argument: creatorId) else {
            fatalError("Failed to resolve CreatorDetailViewModel for creatorId: \(creatorId)")
        }
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._currentCreatorId = State(initialValue: creatorId)
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                loadingView
            case .loaded(let creator, let similarCreators):
                contentView(creator: creator, similarCreators: similarCreators)
            case .error(let title, let message):
                errorView(title: title, message: message)
            }
        }
        .background(Asset.Color.CreatorDetailCard.creatorDetailCardBackground.swiftUIColor)
        .sheet(isPresented: $showingTagApplication) {
            if case .loaded(let creator, _) = viewModel.state {
                TagApplicationView(creator: creator, applicationType: tagApplicationType)
            }
        }
        .sheet(isPresented: $showingProfileCorrection) {
            if case .loaded(let creator, _) = viewModel.state {
                ProfileCorrectionView(creator: creator)
            }
        }
        .confirmationDialog(L10n.CreatorDetail.tagApplication, isPresented: $showingTagApplicationTypeSelection) {
            Button(L10n.CreatorDetail.tagAddApplication) {
                tagApplicationType = .add
                showingTagApplication = true
            }
            
            Button(L10n.CreatorDetail.tagDeleteApplication) {
                tagApplicationType = .remove
                showingTagApplication = true
            }
            
            Button(L10n.Common.cancel, role: .cancel) { }
        } message: {
            Text(L10n.CreatorDetail.tagApplicationTypeSelection)
        }
        .alert("タグ削除申請", isPresented: $showingTagDeleteConfirmation) {
            Button("はい", role: .destructive) {
                tagApplicationType = .remove
                showingTagApplication = true
            }
            Button("いいえ", role: .cancel) { }
        } message: {
            Text("\"\(selectedTagForDeletion)\"の削除を申請しますか？\n\n一度運営が審査するため即座に反映はされません。")
        }
        .task {
            await viewModel.loadCreatorDetail()
        }
    }
    
    // MARK: - State Views
    
    private var loadingView: some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                creatorProfileSectionSkeleton()
                detailSectionSkeleton()
                platformButtonsSectionSkeleton()
                tagsSectionSkeleton()
                similarCreatorsSectionSkeleton()
            }
            .padding(Spacing.screenEdgePadding)
        }
    }
    
    private func errorView(title: String, message: String) -> some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: Typography.titleExtraLarge))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardFavoriteActive.swiftUIColor)
            Text(title)
                .font(.title2)
                .bold()
            Text(message)
                .font(.body)
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
                .multilineTextAlignment(.center)
            Button(L10n.Common.retry) {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                Task {
                    await viewModel.loadCreatorDetail()
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    private func contentView(creator: Creator, similarCreators: [Creator]) -> some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                // Creator profile section
                creatorProfileSection(creator: creator)
                
                detailSection(creator: creator)
                
                // Platform buttons section
                platformButtonsSection(creator: creator)
                
                // Tags section
                tagsSection(creator: creator)
                
                // Similar creators section
                similarCreatorsSection(similarCreators: similarCreators)
            }
            .padding(Spacing.screenEdgePadding)
        }
    }
    
    // MARK: - View Components
    private func creatorProfileSection(creator: Creator) -> some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            // Creator image
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
            
            // Creator name with favorite button
            Text(creator.name)
                .font(.system(size: Typography.titleLarge, weight: .bold))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardTitle.swiftUIColor)
                .multilineTextAlignment(.center)
            
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
                    Text(viewModel.isFavorite ? "お気に入り済み" : "お気に入りに追加")
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
    
    private func detailSection(creator: Creator) -> some View {
        HStack(spacing: Spacing.unrelatedComponentDivider) {
            // 視聴回数
            VStack(spacing: Spacing.relatedComponentDivider) {
               Text(formatViewCount(creator.viewCount))
                    .font(.system(size: Typography.bodyRegular, weight: .bold))
                    .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
                Text("ページ\n閲覧者数")
                    .multilineTextAlignment(.center)
                     .font(.system(size: Typography.bodyRegular, weight: .bold))
                     .foregroundColor(
                        Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor.opacity(0.6)
                     )
            }.frame(maxWidth: .infinity)
            
            // クリック数
            VStack(spacing: Spacing.relatedComponentDivider) {
                Text(formatViewCount(creator.socialLinkClickCount))
                    .font(.system(size: Typography.bodyRegular, weight: .bold))
                    .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
                Text("SNSリンク\nタップ回数")
                    .multilineTextAlignment(.center)
                     .font(.system(size: Typography.bodyRegular, weight: .bold))
                     .foregroundColor(
                        Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor.opacity(0.6)
                     )
            }.frame(maxWidth: .infinity)
            
            // チャンネル登録者数
            VStack(spacing: Spacing.relatedComponentDivider) {
                Text(formatViewCount(creator.favoriteCount))
                    .font(.system(size: Typography.bodyRegular, weight: .bold))
                    .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
                Text("お気に入り\nユーザー数")
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
    
    private func tagsSection(creator: Creator) -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.relatedTags)
                .font(.system(size: Typography.titleMedium, weight: .bold))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
            
            Text("削除を希望する場合はタグを長押ししてください")
                .font(.system(size: Typography.captionSmall))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.componentGrouping) {
                    IlluMefyAddTag()
                    ForEach(creator.relatedTag, id: \.self) { tag in
                        IlluMefyFeaturedTag(
                            text: tag,
                            onLongPress: { tagText in
                                selectedTagForDeletion = tagText
                                showingTagDeleteConfirmation = true
                            },
                            isDeletable: true
                        )
                    }
                }
                .padding(.trailing, Spacing.screenEdgePadding)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(Opacity.glow))
                .frame(width: 100, height: 20)
                .shimmering()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.componentGrouping) {
                    ForEach(0..<5, id: \.self) { _ in
                        IlluMefyFeaturedTag(tagData: nil)
                    }
                }
                .padding(.trailing, Spacing.screenEdgePadding)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
}

#Preview("正常表示") {
    NavigationStack {
        CreatorDetailView(creatorId: "creator_001")
    }
}

#Preview("ローディング中") {
    struct MockLoadingView: View {
        @StateObject private var viewModel = MockCreatorDetailViewModel()
        
        var body: some View {
            Group {
                switch viewModel.state {
                case .loading:
                    Text(L10n.Common.loading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Asset.Color.CreatorDetailCard.creatorDetailCardBackground.swiftUIColor)
                default:
                    Text(L10n.Common.loadingState)
                }
            }
            .onAppear {
                viewModel.state = .loading
            }
        }
    }
    
    return MockLoadingView()
}

#Preview("エラー表示") {
    struct MockErrorView: View {
        @StateObject private var viewModel = MockCreatorDetailViewModel.mockError()
        
        var body: some View {
            Group {
                switch viewModel.state {
                case .error(let title, let message):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: Typography.titleExtraLarge))
                            .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardFavoriteActive.swiftUIColor)
                        Text(title)
                            .font(.title2)
                            .bold()
                        Text(message)
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
                default:
                    Text(L10n.Common.errorState)
                }
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

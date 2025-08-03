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
        .navigationBarHidden(true)
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
        .task {
            await viewModel.loadCreatorDetail()
        }
    }
    
    // MARK: - State Views
    
    private var loadingView: some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            headerSection
            Spacer()
            ProgressView()
                .scaleEffect(Effects.scaleIcon)
            Text(L10n.Common.loading)
                .font(.headline)
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    private func errorView(title: String, message: String) -> some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            headerSection
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
                // Header section with close button
                headerSection
                
                // Creator profile section
                creatorProfileSection(creator: creator)
                
                detailSection(creator: creator)
                
                // Platform buttons section
                platformButtonsSection(creator: creator)
                
                // Tags section
                tagsSection(creator: creator)
                
                // Tag registration section
                tagRegistrationSection
                
                // Information correction section
                informationCorrectionSection
                
                // Similar creators section
                similarCreatorsSection(similarCreators: similarCreators)
            }
            .padding(Spacing.screenEdgePadding)
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        HStack {
            Spacer()
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
            })
        }
    }
    
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
                    .overlay(
                        ProgressView()
                    )
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
            HStack(spacing: Spacing.relatedComponentDivider) {
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
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(
                            viewModel.isFavorite
                                ? Asset.Color.WarningText.warningLabelForground.swiftUIColor
                                : Asset.Color.CreatorDetailCard.creatorDetailCardFavoriteInactive.swiftUIColor
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.componentGrouping) {
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
            Text(L10n.CreatorDetail.tagApplication)
                .font(.system(size: Typography.titleMedium, weight: .bold))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
            
            Text(L10n.CreatorDetail.tagApplicationDescription)
                .font(.system(size: Typography.bodyRegular))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
            
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                showingTagApplicationTypeSelection = true
            }, label: {
                HStack {
                    Text(L10n.CreatorDetail.tagApplicationButton)
                        .font(.system(size: Typography.checkmark, weight: .medium))
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }).illuMefyButtonStyle(isEnabled: true, size: .regular)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var informationCorrectionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.informationCorrection)
                .font(.system(size: Typography.titleMedium, weight: .bold))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSectionTitle.swiftUIColor)
            
            Text(L10n.CreatorDetail.informationCorrectionDescription)
                .font(.system(size: Typography.bodyRegular))
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
                .foregroundColor(Asset.Color.CreatorDetailCard.creatorDetailCardSubtitle.swiftUIColor)
            
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                showingProfileCorrection = true
            }, label: {
                HStack {
                    Text(L10n.CreatorDetail.profileCorrectionButton)
                        .font(.system(size: Typography.checkmark, weight: .medium))
                        .frame(maxWidth: .infinity)
                }
            }).illuMefyButtonStyle(isEnabled: true, size: .regular)
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
                HStack(spacing: Spacing.relatedComponentDivider) {
                    ForEach(similarCreators) { similarCreator in
                        SimilarCreatorCard(creator: similarCreator) {
                            router.navigate(to: .creatorDetail(creatorId: similarCreator.id))
                        }
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

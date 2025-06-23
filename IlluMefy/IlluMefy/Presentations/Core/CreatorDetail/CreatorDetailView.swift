//
//  CreatorDetailView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/13.
//

import SwiftUI

struct CreatorDetailView: View {
    @StateObject private var viewModel: CreatorDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var currentCreatorId: String
    @State private var selectedCreatorId: String?
    @State private var showingCreatorDetail = false
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
        .background(Asset.Color.Application.Background.backgroundPrimary.swiftUIColor)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCreatorDetail) {
            if let selectedCreatorId = selectedCreatorId {
                NavigationStack {
                    CreatorDetailView(creatorId: selectedCreatorId)
                }
            }
        }
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
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
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
                .foregroundColor(Asset.Color.WarningText.warningLabelForground.swiftUIColor)
            Text(title)
                .font(.title2)
                .bold()
            Text(message)
                .font(.body)
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
                .multilineTextAlignment(.center)
            Button(L10n.Common.retry) {
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
                
                // Platform buttons section
                platformButtonsSection(creator: creator)
                
                // Tags section
                tagsSection(creator: creator)
                
                // Tag registration section
                tagRegistrationSection
                
                // Information correction section
                informationCorrectionSection
                
                // Stats section
                statsSection(creator: creator)
                
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
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
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
                    .fill(Asset.Color.TextField.placeholderDisabled.swiftUIColor)
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
                            colors: [Asset.Color.Application.textPrimary.swiftUIColor.opacity(Opacity.glow), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: BorderWidth.extraThick + BorderWidth.thin
                    )
            )
            .shadow(
                color: Asset.Color.Application.Background.backgroundPrimary.swiftUIColor.opacity(Opacity.overlayMedium),
                radius: Shadow.radiusMedium,
                x: 0,
                y: Shadow.offsetYMedium
            )
            
            // Creator name with favorite button
            HStack(spacing: Spacing.relatedComponentDivider) {
                Text(creator.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: AnimationDuration.heartBeat)) {
                        viewModel.toggleFavorite()
                    }
                }, label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(
                            viewModel.isFavorite
                                ? Asset.Color.WarningText.warningLabelForground.swiftUIColor
                                : Asset.Color.Application.textPrimary.swiftUIColor.opacity(Opacity.overlayHeavy)
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
            
            // Main platform indicator
            HStack {
                let (platform, _) = creator.mainPlatform()
                if platform == .youtube {
                    Image(systemName: platform.icon)
                        .font(.system(size: Typography.bodyRegular))
                        .foregroundColor(Asset.Color.WarningText.warningLabelForground.swiftUIColor)
                } else {
                    Image(platform.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Size.smallIconSize, height: Size.smallIconSize)
                }
                Text(L10n.CreatorDetail.mainPlatform)
                    .font(.caption)
                    .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
            }
        }
    }
    
    private func platformButtonsSection(creator: Creator) -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.snsLinks)
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
    
    private func tagsSection(creator: Creator) -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.relatedTags)
                .font(.headline)
                .bold()
            
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
                .font(.headline)
                .bold()
            
            Text(L10n.CreatorDetail.tagApplicationDescription)
                .font(.subheadline)
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
            
            Button(action: {
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
                .font(.headline)
                .bold()
            
            Text(L10n.CreatorDetail.informationCorrectionDescription)
                .font(.subheadline)
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
            
            Button(action: {
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
    
    private func statsSection(creator: Creator) -> some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.statistics)
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: Spacing.unrelatedComponentDivider) {
                StatCard(
                    title: L10n.CreatorDetail.totalViews,
                    value: formatViewCount(creator.viewCount),
                    icon: "eye.fill"
                )
                
                StatCard(
                    title: L10n.CreatorDetail.snsClicks,
                    value: formatViewCount(creator.socialLinkClickCount),
                    icon: "link"
                )
                
                StatCard(
                    title: L10n.CreatorDetail.platforms,
                    value: "\(creator.platform.count)",
                    icon: "square.grid.2x2"
                )
            }
        }
    }
    
    private func similarCreatorsSection(similarCreators: [Creator]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.CreatorDetail.similarCreators)
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(L10n.CreatorDetail.similarCreatorsDescription)
                .font(.subheadline)
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.relatedComponentDivider) {
                    ForEach(similarCreators) { similarCreator in
                        SimilarCreatorCard(creator: similarCreator) {
                            selectedCreatorId = similarCreator.id
                            showingCreatorDetail = true
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
                        .background(Asset.Color.Application.Background.backgroundPrimary.swiftUIColor)
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
                            .foregroundColor(Asset.Color.WarningText.warningLabelForground.swiftUIColor)
                        Text(title)
                            .font(.title2)
                            .bold()
                        Text(message)
                            .font(.body)
                            .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
                            .multilineTextAlignment(.center)
                        Button(L10n.Common.retry) {
                            // Dummy action
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Asset.Color.Application.Background.backgroundPrimary.swiftUIColor)
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
        @State private var selectedCreator: String?
        @State private var showingDetail = false
        
        var body: some View {
            NavigationStack {
                VStack {
                    Text(L10n.Common.navigationTest)
                        .font(.title)
                    
                    Button(L10n.Common.openCreatorDetail) {
                        selectedCreator = "creator_001"
                        showingDetail = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .sheet(isPresented: $showingDetail) {
                    if let creatorId = selectedCreator {
                        NavigationStack {
                            CreatorDetailView(creatorId: creatorId)
                        }
                    }
                }
            }
        }
    }
    
    return NavigationTestView()
}

//
//  DevelopmentTabView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/09.
//

import SwiftUI
struct DevelopmentTabView: View {
    @State private var viewModel: DevelopmentTabViewViewModel = DependencyContainer.shared.resolve(DevelopmentTabViewViewModel.self)!
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                content
            }.padding(Spacing.screenEdgePadding)
        }
        .onAppear {
            Task {
                await viewModel.loadDevelopmentStatus()
            }
        }
    }
    
    private var content: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            if viewModel.isLoading {
                ProgressView(L10n.Common.loading)
                    .frame(maxWidth: .infinity)
            } else {
                Text(viewModel.developmentStatusText)
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    DevelopmentTabView()
}

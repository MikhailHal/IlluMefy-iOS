import SwiftUI

struct GroupListView: View {
    @StateObject private var viewModel = GroupListViewModel()
    @EnvironmentObject var router: NimliAppRouter
    
    init() {
        configureNavigationBarAppearance()
    }
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.screenBackground
        appearance.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .title3),
            .foregroundColor: UIColor.textForeground
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            Color.screenBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.relatedComponentDivider) {
                    ForEach(viewModel.groups) { group in
                        GroupCard(group: group)
                            .onTapGesture {
                                viewModel.selectGroup(group)
                            }
                    }
                }
                .padding(.horizontal, Spacing.screenEdgePadding)
                .padding(.top, Spacing.screenEdgePadding)
            }
        }
        .navigationTitle("グループ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.createNewGroup()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.textForeground)
                }
            }
        }
    }
}

struct GroupCard: View {
    let group: UserGroup
    
    var body: some View {
        HStack(spacing: Spacing.componentGrouping) {
            // グループアイコン
            ZStack {
                Circle()
                    .fill(Color.buttonBackgroundPositive.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "person.3.fill")
                    .foregroundColor(.buttonBackgroundPositive)
                    .font(.system(size: 24))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.headline)
                    .foregroundColor(.textForeground)
                
                HStack {
                    Text("\(group.memberCount)人")
                        .font(.subheadline)
                        .foregroundColor(.textForeground.opacity(0.6))
                    
                    Text("・")
                        .foregroundColor(.textForeground.opacity(0.6))
                    
                    Text(formatDate(group.lastUpdated))
                        .font(.subheadline)
                        .foregroundColor(.textForeground.opacity(0.6))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.textForeground.opacity(0.3))
        }
        .padding(Spacing.cardEdgePadding)
        .background(Color.cardFillColorNormal)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    GroupListView()
        .environmentObject(NimliAppRouter())
} 
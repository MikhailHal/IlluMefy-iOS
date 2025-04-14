import SwiftUI

struct GroupDetailView: View {
    @StateObject private var viewModel = GroupDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.unrelatedComponentDivider) {
                // グループ情報セクション
                groupInfoSection
                
                // メンバーセクション
                membersSection
                
                // アクションセクション
                actionSection
            }
            .padding(Spacing.screenEdgePadding)
        }
        .background(Color("ScreenBackground"))
        .navigationTitle("グループ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // 設定画面へ遷移
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color("TextForeground"))
                }
            }
        }
    }
    
    // グループ情報セクション
    private var groupInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            Text("グループ情報")
                .font(.headline)
                .foregroundColor(Color("TextForeground"))
            
            VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
                HStack {
                    Text("グループ名")
                        .foregroundColor(Color("TextForeground"))
                    Spacer()
                    Text(viewModel.groupName)
                        .foregroundColor(Color("TextForeground"))
                }
                
                HStack {
                    Text("作成日")
                        .foregroundColor(Color("TextForeground"))
                    Spacer()
                    Text(viewModel.createdAt)
                        .foregroundColor(Color("TextForeground"))
                }
            }
            .padding(Spacing.cardEdgePadding)
            .background(Color("CardFillColorNormal"))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
    
    // メンバーセクション
    private var membersSection: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            HStack {
                Text("メンバー")
                    .font(.headline)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
                Button {
                    // メンバー招待
                } label: {
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(Color("Positive"))
                }
            }
            
            VStack(spacing: Spacing.relatedComponentDivider) {
                ForEach(viewModel.members) { member in
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color("Positive"))
                        
                        VStack(alignment: .leading) {
                            Text(member.name)
                                .foregroundColor(Color("TextForeground"))
                            Text(member.email)
                                .font(.caption)
                                .foregroundColor(Color("TextForeground"))
                        }
                        
                        Spacer()
                        
                        if member.isAdmin {
                            Text("管理者")
                                .font(.caption)
                                .padding(.horizontal, Spacing.componentGrouping)
                                .padding(.vertical, 4)
                                .background(Color("Positive").opacity(0.1))
                                .foregroundColor(Color("Positive"))
                                .cornerRadius(8)
                        }
                    }
                    .padding(Spacing.cardEdgePadding)
                    .background(Color("CardFillColorNormal"))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // アクションセクション
    private var actionSection: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            if viewModel.isCurrentUserAdmin {
                NimliButton(
                    text: "メンバーを招待する",
                    isEnabled: true,
                    onClick: {
                        viewModel.inviteMember()
                    },
                    leadingIcon: AnyView(
                        Image(systemName: "person.badge.plus")
                    )
                )
            }
            
            NimliButton(
                text: "グループを退出する",
                isEnabled: false,
                onClick: {
                    // グループ退出の処理
                },
                leadingIcon: AnyView(
                    Image(systemName: "person.fill.xmark")
                )
            )
        }
    }
}

// プレビュー
#Preview {
    NavigationStack {
        GroupDetailView()
    }
}

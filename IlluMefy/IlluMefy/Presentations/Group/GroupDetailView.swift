//
//  GroupDetailView.swift
//  IlluMefy
//
//  Created by Haruto Islay on 2024/04/14.
//

import SwiftUI

/// View for the group detail screen
///
/// Displays basic group information, member list, and various action buttons.
/// This view works in conjunction with `GroupDetailViewModel` to present
/// detailed group information to the user.
///
/// - Note: This view requires a ViewModel that conforms to `GroupDetailViewModelProtocol`.
///   Use mock objects for testing.
///
/// # Usage Example
/// ```swift
/// let viewModel = GroupDetailViewModel()
/// GroupDetailView(viewModel: viewModel)
/// ```
///
/// - Author: Haruto Islay
/// - Version: 1.0.0
struct GroupDetailView: View {
    /// ViewModel for the group detail screen
    @StateObject private var viewModel: GroupDetailViewModel
    
    /// Initializes the group detail view
    ///
    /// - Parameter viewModel: ViewModel for the group detail screen
    init(viewModel: GroupDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Group information section
                groupInfoSection
                
                // Member list section
                membersSection
                
                // Action buttons section
                actionButtonsSection
            }
            .padding()
        }
        .navigationTitle("グループ詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /// Section displaying group information
    ///
    /// Shows group name, creation date, and administrator information.
    /// The group name is editable, and the edit button is only visible
    /// to users with administrator privileges.
    private var groupInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Group name
            HStack {
                if viewModel.isEditingGroupName {
                    TextField("グループ名", text: $viewModel.editingGroupName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("保存") {
                        viewModel.saveGroupName()
                    }
                    
                    Button("キャンセル") {
                        viewModel.cancelEditingGroupName()
                    }
                } else {
                    Text(viewModel.groupName)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if viewModel.isCurrentUserAdmin {
                        Button(action: {
                            viewModel.startEditingGroupName()
                        },
                               label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        })
                    }
                }
            }
            
            // Creation date
            HStack {
                Image(systemName: "calendar")
                Text("作成日: \(viewModel.createdAt)")
            }
            .foregroundColor(.gray)
            
            // Administrator information
            if viewModel.isCurrentUserAdmin {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("あなたは管理者です")
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    /// Section displaying the member list
    ///
    /// Shows a list of group members.
    /// Displays each member's name, email address, and administrator status.
    private var membersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("メンバー")
                .font(.headline)
            
            ForEach(viewModel.members) { member in
                HStack {
                    VStack(alignment: .leading) {
                        Text(member.name)
                            .fontWeight(.medium)
                        Text(member.email)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    if member.isAdmin {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                    }
                }
                .padding(.vertical, 8)
                
                if member.id != viewModel.members.last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    /// Section displaying action buttons
    ///
    /// Shows buttons for actions like inviting members and leaving the group.
    /// The buttons displayed vary depending on administrator privileges.
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            if viewModel.isCurrentUserAdmin {
                Button(action: {
                    viewModel.inviteMember()
                }, label: {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("メンバーを招待")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                })
            }
            
            Button(action: {
                viewModel.leaveGroup()
            }, label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("グループから退出")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            })
        }
    }
}

// Preview
#Preview {
    NavigationStack {
        GroupDetailView(viewModel: GroupDetailViewModel())
    }
}

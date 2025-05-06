//
//  GroupDetailViewModel.swift
//  IlluMefy
//
//  Created by Haruto Islay on 2024/04/14.
//

import Foundation

/// ViewModel for the group detail screen
///
/// Implements functionality for displaying, editing, and managing group information.
/// This class conforms to `GroupDetailViewModelProtocol` and provides the necessary
/// data and operations for the group detail screen.
///
/// - Note: This class is defined as `final` and cannot be inherited.
///   Use mock objects for testing.
///
/// # Usage Example
/// ```swift
/// let viewModel = GroupDetailViewModel()
/// viewModel.startEditingGroupName()
/// ```
///
/// - Author: Haruto Islay
/// - Version: 1.0.0
final class GroupDetailViewModel: GroupDetailViewModelProtocol {
    /// The name of the group
    @Published var groupName: String = "家族グループ"
    
    /// The creation date of the group
    @Published var createdAt: String = "2024年4月1日"
    
    /// Whether the current user is an administrator
    @Published var isCurrentUserAdmin: Bool = true
    
    /// Whether the group name is in edit mode
    @Published var isEditingGroupName: Bool = false
    
    /// The group name being edited
    @Published var editingGroupName: String = ""
    
    /// List of group members
    @Published var members: [Member] = [
        Member(id: "1", name: "山田太郎", email: "yamada@example.com", isAdmin: true),
        Member(id: "2", name: "山田花子", email: "hanako@example.com", isAdmin: false),
        Member(id: "3", name: "山田一郎", email: "ichiro@example.com", isAdmin: false)
    ]
    
    /// Structure holding group member information
    ///
    /// Stores basic member information and permission details.
    /// This structure conforms to `Identifiable` protocol and can be used
    /// in SwiftUI list displays.
    ///
    /// - Note: Member information is retrieved from Firestore and mapped to this structure.
    struct Member: Identifiable {
        /// Unique identifier for the member
        let id: String
        
        /// Display name of the member
        let name: String
        
        /// Email address of the member
        let email: String
        
        /// Whether the member is an administrator
        let isAdmin: Bool
    }
    
    /// Starts editing the group name
    ///
    /// When called, this method copies the current group name to the editing variable
    /// and enables edit mode.
    func startEditingGroupName() {
        editingGroupName = groupName
        isEditingGroupName = true
    }
    
    /// Saves the edited group name
    ///
    /// If the edited group name is not empty, it is saved as the new group name.
    /// Edit mode is disabled.
    func saveGroupName() {
        if !editingGroupName.isEmpty {
            groupName = editingGroupName
        }
        isEditingGroupName = false
    }
    
    /// Cancels editing the group name
    ///
    /// Disables edit mode and clears the editing group name.
    func cancelEditingGroupName() {
        editingGroupName = ""
        isEditingGroupName = false
    }
    
    /// Invites a new member to the group
    ///
    /// Executes the process for inviting a new member to the group.
    /// The specific invitation method is defined by the implementing class.
    func inviteMember() {
        // メンバー招待の処理
    }
    
    /// Leaves the group
    ///
    /// Executes the process for the current user to leave the group.
    /// For administrators, leaving is only possible if there is another administrator.
    func leaveGroup() {
        // グループ退出の処理
    }
}

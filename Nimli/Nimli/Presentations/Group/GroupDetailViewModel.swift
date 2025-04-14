import Foundation

class GroupDetailViewModel: ObservableObject {
    @Published var groupName: String = "家族グループ"
    @Published var createdAt: String = "2024年4月1日"
    @Published var isCurrentUserAdmin: Bool = true
    @Published var members: [Member] = [
        Member(id: "1", name: "山田太郎", email: "yamada@example.com", isAdmin: true),
        Member(id: "2", name: "山田花子", email: "hanako@example.com", isAdmin: false),
        Member(id: "3", name: "山田一郎", email: "ichiro@example.com", isAdmin: false)
    ]
    
    struct Member: Identifiable {
        let id: String
        let name: String
        let email: String
        let isAdmin: Bool
    }
    
    func inviteMember() {
        // メンバー招待の処理
    }
    
    func leaveGroup() {
        // グループ退出の処理
    }
}

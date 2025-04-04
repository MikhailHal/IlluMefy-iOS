import Foundation

class GroupListViewModel: ObservableObject {
    @Published var groups: [UserGroup] = []
    
    init() {
        // サンプルデータを読み込む
        loadSampleData()
    }
    
    private func loadSampleData() {
        groups = UserGroup.samples
    }
    
    func createNewGroup() {
        let newGroup = UserGroup(
            id: UUID().uuidString,
            name: "新規グループ",
            memberCount: 1,
            lastUpdated: Date(),
            imageUrl: nil
        )
        groups.append(newGroup)
    }
    
    func selectGroup(_ group: UserGroup) {
        // TODO: グループ詳細画面への遷移
    }
} 
import Foundation

struct UserGroup: Identifiable {
    let id: String
    let name: String
    let memberCount: Int
    let lastUpdated: Date
    let imageUrl: String?
    
    // サンプルデータ
    static let samples = [
        UserGroup(id: "1", name: "家族", memberCount: 4, lastUpdated: Date(), imageUrl: nil),
        UserGroup(id: "2", name: "カップル", memberCount: 2, lastUpdated: Date().addingTimeInterval(-86400), imageUrl: nil),
        UserGroup(id: "3", name: "ルームメイト", memberCount: 3, lastUpdated: Date().addingTimeInterval(-172800), imageUrl: nil)
    ]
}

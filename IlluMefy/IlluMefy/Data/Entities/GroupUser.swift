import Foundation

struct GroupUser: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let groupId: UUID
    let isAdmin: Bool
    let joinedAt: Date
    let updatedAt: Date
    
    init(
        id: UUID = UUID(),
        userId: UUID,
        groupId: UUID,
        isAdmin: Bool = false,
        joinedAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.groupId = groupId
        self.isAdmin = isAdmin
        self.joinedAt = joinedAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Equatable
extension GroupUser: Equatable {
    static func == (lhs: GroupUser, rhs: GroupUser) -> Bool {
        lhs.id == rhs.id &&
        lhs.userId == rhs.userId &&
        lhs.groupId == rhs.groupId &&
        lhs.isAdmin == rhs.isAdmin &&
        lhs.joinedAt == rhs.joinedAt &&
        lhs.updatedAt == rhs.updatedAt
    }
}

// MARK: - Hashable
extension GroupUser: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(userId)
        hasher.combine(groupId)
        hasher.combine(isAdmin)
        hasher.combine(joinedAt)
        hasher.combine(updatedAt)
    }
}

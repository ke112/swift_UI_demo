import Foundation

struct Message: Identifiable {
    let id = UUID()
    let avatar: String
    let name: String
    let content: String
    let time: String
    var unreadCount: Int
} 
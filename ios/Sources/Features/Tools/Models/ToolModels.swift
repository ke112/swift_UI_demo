import Foundation

struct Tool: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let isNew: Bool
}

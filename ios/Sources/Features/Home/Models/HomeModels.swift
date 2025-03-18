import Foundation

struct Post: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
    var likes: Int
    let height: CGFloat
    var isLike: Bool
}

struct HomeItem: Identifiable {
    let id: Int
    let title: String
} 

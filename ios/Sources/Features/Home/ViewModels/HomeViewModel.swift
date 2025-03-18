import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "推荐"
    @Published var categories = ["关注", "推荐", "热榜", "科技", "财经"]
    @Published var posts = [
        Post(image: "person.fill", title: "4岁登台...", description: "如今年31岁...", likes: 67),
        Post(image: "star.fill", title: "感谢deepseek...", description: "20天赚了15000", likes: 502),
        Post(image: "heart.fill", title: "40岁女演员...", description: "气质依旧", likes: 320)
    ]
    
    let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func performSearch() {
        // 执行搜索逻辑
        print("Searching for: \(searchText)")
    }
    
    func selectCategory(_ category: String) {
        selectedCategory = category
        // 根据选择的分类加载数据
        loadPosts(for: category)
    }
    
    func loadPosts(for category: String) {
        // 根据分类加载帖子
        print("Loading posts for category: \(category)")
    }
    
    func likePost(_ post: Post) {
        // 处理点赞逻辑
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].likes += 1
        }
    }
} 

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "推荐"
    @Published var categories = ["关注", "推荐", "热榜", "科技", "财经"]
    @Published var posts: [Post] = []
    
    // 定义瀑布流布局的列
    let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        generatePosts()
    }
    
    private func generatePosts() {
        let titles = ["4岁登台...", "感谢deepseek...", "40岁女演员...", "新款手机发布", 
                      "股市大涨", "火爆综艺", "新科技突破", "旅游胜地", "美食推荐", "健康生活"]
        let descriptions = ["如今年31岁...", "20天赚了15000", "气质依旧", "性能提升50%", 
                            "创历史新高", "收视率第一", "改变生活方式", "风景如画", "美味佳肴", "科学健身"]
        
        posts = (0..<20).map { i in
            // 使用 Picsum 的随机图片 URL
            let imageUrl = "https://picsum.photos/400/300?random=\(i)"
            
            // 随机生成100-150之间的高度
            let randomHeight = CGFloat.random(in: 100...150)
            
            return Post(
                image: imageUrl,
                title: "\(titles[i % titles.count])\(i + 1)",
                description: "\(descriptions[i % descriptions.count])\(i + 1)",
                likes: Int.random(in: 10...999),
                height: randomHeight,
                isLike: false
            )
        }
    }
    
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
            if posts[index].isLike {
                // 如果已经点赞，减少点赞数
                posts[index].likes -= 1
            } else {
                // 如果未点赞，增加点赞数
                posts[index].likes += 1
            }
            // 切换点赞状态
            posts[index].isLike.toggle()
        }
    }
}

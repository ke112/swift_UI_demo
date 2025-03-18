import Foundation

class HomeViewModel: ObservableObject {
    @Published var items: [HomeItem] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func loadData() {
        isLoading = true
        // TODO: 实现数据加载逻辑
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.items = [
                HomeItem(id: 1, title: "示例项目1"),
                HomeItem(id: 2, title: "示例项目2"),
                HomeItem(id: 3, title: "示例项目3")
            ]
            self.isLoading = false
        }
    }
}

struct HomeItem: Identifiable {
    let id: Int
    let title: String
} 
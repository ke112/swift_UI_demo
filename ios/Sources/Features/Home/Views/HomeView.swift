import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // 搜索栏
                HStack {
                    TextField("怎样缓解孕车的症状", text: $viewModel.searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    Button(action: viewModel.performSearch) {
                        Text("搜索")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()

                // 分类标签
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(action: { viewModel.selectCategory(category) }) {
                                Text(category)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(viewModel.selectedCategory == category ? Color.blue : Color(.systemGray6))
                                    .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // 瀑布流内容列表
                ScrollView {
                    WaterfallGrid(items: viewModel.posts, columns: 2) { post in
                        PostView(post: post, onLike: { _ in viewModel.likePost(post) })
                    }
                    .padding()
                }
            }
            .navigationTitle("搜索")
        }
    }
}

// 瀑布流布局组件
struct WaterfallGrid<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let columns: Int
    let content: (Item) -> Content

    init(items: [Item], columns: Int, @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.columns = columns
        self.content = content
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ForEach(0 ..< columns, id: \.self) { columnIndex in
                LazyVStack(spacing: 10) {
                    ForEach(items.indices.filter { $0 % columns == columnIndex }, id: \.self) { index in
                        content(items[index])
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

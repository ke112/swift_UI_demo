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
            ForEach(0..<columns, id: \.self) { columnIndex in
                LazyVStack(spacing: 10) {
                    ForEach(items.indices.filter { $0 % columns == columnIndex }, id: \.self) { index in
                        content(items[index])
                    }
                }
            }
        }
    }
}

import SwiftUI

struct PostView: View {
    let post: Post // 改为常量
    let onLike: (Post) -> Void
    
    @State private var isLiked: Bool // 单独跟踪点赞状态
    @State private var uiImage: UIImage? = nil
    @State private var isLoading: Bool = true
    
    init(post: Post, onLike: @escaping (Post) -> Void) {
        self.post = post
        self.onLike = onLike
        _isLiked = State(initialValue: post.isLike) // 初始化 isLiked
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: post.height)
                    .clipped()
                    .cornerRadius(8)
            } else if isLoading {
                Color(.systemGray5)
                    .frame(maxWidth: .infinity, minHeight: 120)
            }

            Text(post.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(post.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            Button(action: {
                isLiked.toggle() // 切换本地状态
                var updatedPost = post
                updatedPost.isLike = isLiked
                onLike(updatedPost) // 传递更新后的 post
            }) {
                HStack {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                    Text("\(post.likes)") // 只在点赞时增加1
                }
                .font(.caption)
                .foregroundColor(isLiked ? .red : .gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        LoggerUtil.shared.log(message: post.image)
        guard let url = URL(string: post.image) else { return }
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uiImage = image
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 

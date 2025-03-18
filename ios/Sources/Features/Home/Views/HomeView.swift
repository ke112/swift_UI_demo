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
                
                // 内容列表
                ScrollView {
                    LazyVGrid(columns: viewModel.gridColumns, spacing: 20) {
                        ForEach(viewModel.posts) { post in
                            PostView(post: post, onLike: { viewModel.likePost(post) })
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("搜索")
        }
    }
}

struct PostView: View {
    let post: Post
    let onLike: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: post.image)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            
            Text(post.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(post.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            Button(action: onLike) {
                HStack {
                    Image(systemName: "heart")
                    Text("\(post.likes)")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 

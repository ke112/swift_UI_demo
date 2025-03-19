//
//  PostView.swift
//  ios
//
//  Created by ks on 2025/3/19.
//


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

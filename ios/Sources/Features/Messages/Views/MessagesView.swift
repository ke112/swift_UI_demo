import SwiftUI

struct MessagesView: View {
    @StateObject private var viewModel = MessagesViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.messages) { message in
                    MessageRow(message: message)
                        .contextMenu {
                            Button(action: {
                                viewModel.markAsRead(message)
                            }) {
                                Label("标记已读", systemImage: "checkmark")
                            }
                            
                            Button(action: {
                                viewModel.deleteMessage(message)
                            }) {
                                Label("删除", systemImage: "trash")
                            }
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.deleteMessage(viewModel.messages[index])
                    }
                }
            }
            .navigationTitle("消息")
            .background(
                RefreshControl(coordinateSpace: .named("RefreshControl")) {
                    await viewModel.refreshMessages()
                }
            )
        }
    }
}

// 自定义的RefreshControl视图
struct RefreshControl: View {
    let coordinateSpace: CoordinateSpace
    let onRefresh: () async -> Void
    
    @State private var refresh: Bool = false
    @State private var frozen: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.frame(in: coordinateSpace).midY > 50 {
                Spacer()
                    .onAppear {
                        if !refresh {
                            refresh = true
                            
                            Task {
                                await onRefresh()
                                refresh = false
                            }
                        }
                    }
            } else if geometry.frame(in: coordinateSpace).maxY < 1 {
                Spacer()
                    .onAppear {
                        refresh = false
                    }
            }
            ZStack(alignment: .center) {
                if refresh {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(width: 35, height: 35)
                        .position(x: geometry.frame(in: .local).midX, y: 20)
                }
            }
        }
        .frame(height: 0)
    }
}

struct MessageRow: View {
    let message: Message
    
    var body: some View {
        HStack {
            Image(systemName: message.avatar)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(message.name)
                        .font(.headline)
                    Spacer()
                    Text(message.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(message.content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            if message.unreadCount > 0 {
                Spacer()
                Text("\(message.unreadCount)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .background(Color.red)
                    .clipShape(Circle())
            }
        }
        .padding(.vertical, 8)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
} 
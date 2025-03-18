import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let avatar: String
    let name: String
    let content: String
    let time: String
    let unreadCount: Int
}

struct MessagesView: View {
    @State private var messages = [
        Message(avatar: "person.circle.fill", name: "系统通知", content: "欢迎使用APP", time: "刚刚", unreadCount: 1),
        Message(avatar: "bell.circle.fill", name: "活动消息", content: "您有一个新的活动待参加", time: "10分钟前", unreadCount: 2),
        Message(avatar: "envelope.circle.fill", name: "订阅消息", content: "您关注的内容有更新", time: "30分钟前", unreadCount: 0)
    ]
    
    var body: some View {
        NavigationView {
            List(messages) { message in
                HStack {
                    Image(systemName: message.avatar)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 5) {
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
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("消息")
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
} 
import Combine
import Foundation
import SwiftUI

@MainActor
class MessagesViewModel: ObservableObject {
    @Published var messages: [Message] = [
        Message(avatar: "person.circle.fill", name: "张三", content: "你好,最近怎么样?", time: "10:30", unreadCount: 2),
        Message(avatar: "person.circle.fill", name: "李四", content: "周末有空吗?", time: "09:15", unreadCount: 0),
        Message(avatar: "person.circle.fill", name: "王五", content: "项目进展如何?", time: "昨天", unreadCount: 1),
    ]

    func markAsRead(_ message: Message) {
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            messages[index].unreadCount = 0
        }
    }

    func deleteMessage(_ message: Message) {
        messages.removeAll { $0.id == message.id }
    }

    func refreshMessages() async {
        // 模拟网络请求延迟
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1秒

        // 在主线程更新UI
        await MainActor.run {
            messages = [
                Message(avatar: "person.circle.fill", name: "张三", content: "新消息来啦!", time: "刚刚", unreadCount: 1),
                Message(avatar: "person.circle.fill", name: "李四", content: "周末有空吗?", time: "09:15", unreadCount: 0),
                Message(avatar: "person.circle.fill", name: "王五", content: "项目进展如何?", time: "昨天", unreadCount: 1),
            ]
        }
    }
}

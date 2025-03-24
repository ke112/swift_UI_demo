import Combine
import SwiftUI

class ToolsViewModel: ObservableObject {
    @Published var tools = [
        Tool(icon: "brain.head.profile", title: "天工大模型3.0", description: "初次见面很开心...", isNew: false),
        Tool(icon: "pencil", title: "AI 写作", description: "我能帮你快速撰写各类...", isNew: false),
        Tool(icon: "doc.text.magnifyingglass", title: "AI 文档-音视频分析", description: "我能帮你快速生成...", isNew: true),
        Tool(icon: "music.note", title: "AI 音乐", description: "天工AI音乐的首步", isNew: false),
        Tool(icon: "doc.on.doc", title: "AI PPT", description: "你好，我是你的AI PPT...", isNew: true),
    ]

    func openTool(_ tool: Tool) {
        // 处理工具点击事件
        print("Opening tool: \(tool.title)")
    }
}

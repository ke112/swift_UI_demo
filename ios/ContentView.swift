//
//  ContentView.swift
//  ios
//
//  Created by ks on 2025/3/15.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var count: Int = 0
    @State private var tipsTitle: String = "点击获取GitHub事件"
    @State private var isLoading: Bool = false
    @State private var events: [GitHubEvent] = [] // 新增状态变量存储事件列表
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                count += 1
                // 使用通用日志工具类输出信息
                LoggerUtil.shared.info("按钮点击 - 当前值: \(count)")
                
                // 使用埋点工具类记录事件（包含设备公共参数）
                AnalyticsUtil.shared.trackClick(
                    origin: "main",
                    entity: "counter",
                    spec: ["count_value": count]
                )
                
                // 调用GitHub API
                fetchGithubData()
            }) {
                Text("增加")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                Text(tipsTitle)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            
            // 添加事件列表展示
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(events) { event in
                        HStack {
                            Text("ID: \(event.id)")
                                .font(.system(.body, design: .monospaced))
                            Spacer()
                            Text(event.type)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                    }
                }
                .padding()
            }
            .frame(maxHeight: 300) // 限制最大高度
        }
        .padding()
        .onAppear {
            // 请求通知权限（用于获取通知状态）
            requestNotificationPermission()
            
            // 设置用户ID示例（实际项目中可能来自登录服务）
            AnalyticsUtil.shared.setUserId("test_user_123")
            
//            AnalyticsUtil.shared.trackShow(
//                origin: "main",
//                entity: "counter",
//                spec: ["count_value": count]
//            )
        }
    }
    
    // 请求通知权限
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                LoggerUtil.shared.error("通知权限请求失败: \(error.localizedDescription)")
            }
        }
    }
    
    // 获取GitHub数据
    private func fetchGithubData() {
        isLoading = true
        events = [] // 清空之前的数据
        
        let urlString = "https://api.github.com/events"
        
        NetworkUtil.shared.get(
            urlString: urlString
        ) { (result: Result<[GitHubEvent], Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    self.events = response // 保存获取到的事件列表
                    let count = response.count
                    self.tipsTitle = "获取GitHub事件成功:\n共有 \(count) 条事件"
                    LoggerUtil.shared.info("获取GitHub事件成功: 共有 \(count) 条事件")
                    
                case .failure(let error):
                    self.tipsTitle = "获取数据失败: \(error.localizedDescription)"
                    LoggerUtil.shared.error("获取GitHub事件失败: \(error.localizedDescription)")
                }
            }
        }
    }
}

//#Preview {
//    ContentView()
//}

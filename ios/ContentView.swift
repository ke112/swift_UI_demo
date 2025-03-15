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
            }) {
                Text("增加")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            // 请求通知权限（用于获取通知状态）
            requestNotificationPermission()
            
            // 设置用户ID示例（实际项目中可能来自登录服务）
            AnalyticsUtil.shared.setUserId("test_user_123")
            
            AnalyticsUtil.shared.trackShow(
                origin: "main",
                entity: "counter",
                spec: ["count_value": count]
            )
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
}

//#Preview {
//    ContentView()
//}

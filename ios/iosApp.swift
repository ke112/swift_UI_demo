//
//  iosApp.swift
//  ios
//
//  Created by ks on 2025/3/15.
//

import SwiftUI

// AppDelegate类现在作为内部类
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setupAnalytics()
        setupLogger()
        return true
    }
    
    private func setupAnalytics() {
        // 配置分析服务
        AnalyticsUtil.shared.trackShow(origin: "app", entity: "launch")
    }
    
    private func setupLogger() {
        // 配置日志服务
        LoggerUtil.shared.info("应用启动")
    }
}

@main
struct iosApp: App {
    // 使用UIApplicationDelegateAdaptor将AppDelegate与SwiftUI生命周期关联
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

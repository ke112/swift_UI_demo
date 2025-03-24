import SwiftUI

struct ProfileFeature: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: String
}

class ProfileViewModel: ObservableObject {
    @Published var userName = "用户名"
    @Published var userAvatar = "person.circle.fill"
    @Published var userDescription = "查看或编辑个人资料"

    @Published var commonFeatures = [
        ProfileFeature(title: "设置", icon: "gear", destination: "设置"),
        ProfileFeature(title: "消息通知", icon: "bell", destination: "消息通知"),
        ProfileFeature(title: "帮助与反馈", icon: "questionmark.circle", destination: "帮助与反馈"),
    ]

    @Published var otherFeatures = [
        ProfileFeature(title: "关于", icon: "info.circle", destination: "关于"),
    ]

    func editProfile() {
        // 编辑个人资料
        print("Editing profile...")
    }

    func navigateToFeature(_ feature: ProfileFeature) {
        // 处理功能导航
        print("Navigating to: \(feature.title)")
    }

    func logout() {
        // 处理登出
        print("Logging out...")
    }
}

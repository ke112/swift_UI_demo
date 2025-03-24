import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("搜索")
                }
                .tag(0)

            ToolsView()
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("工具")
                }
                .tag(1)

            MessagesView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("消息")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("我的")
                }
                .tag(3)
        }
    }
}

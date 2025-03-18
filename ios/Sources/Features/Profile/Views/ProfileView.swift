import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: EmptyView()) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("用户名")
                                .font(.headline)
                            Text("查看或编辑个人资料")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("常用功能").padding(.top)) {
                    NavigationLink(destination: Text("设置")) {
                        Label("设置", systemImage: "gear")
                    }
                    NavigationLink(destination: Text("消息通知")) {
                        Label("消息通知", systemImage: "bell")
                    }
                    NavigationLink(destination: Text("帮助与反馈")) {
                        Label("帮助与反馈", systemImage: "questionmark.circle")
                    }
                }
                
                Section(header: Text("其他").padding(.top)) {
                    NavigationLink(destination: Text("关于")) {
                        Label("关于", systemImage: "info.circle")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("我的")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
} 
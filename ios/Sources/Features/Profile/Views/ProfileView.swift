import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: viewModel.editProfile) {
                        HStack {
                            Image(systemName: viewModel.userAvatar)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text(viewModel.userName)
                                    .font(.headline)
                                Text(viewModel.userDescription)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }

                Section(header: Text("常用功能")) {
                    ForEach(viewModel.commonFeatures) { feature in
                        NavigationLink(destination: Text(feature.destination)) {
                            Label(feature.title, systemImage: feature.icon)
                        }
                    }
                }

                Section(header: Text("其他")) {
                    ForEach(viewModel.otherFeatures) { feature in
                        NavigationLink(destination: Text(feature.destination)) {
                            Label(feature.title, systemImage: feature.icon)
                        }
                    }

                    Button(action: viewModel.logout) {
                        Text("退出登录")
                            .foregroundColor(.red)
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

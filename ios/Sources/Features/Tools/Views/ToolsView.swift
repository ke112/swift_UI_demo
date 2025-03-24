import SwiftUI

struct ToolsView: View {
    @StateObject private var viewModel = ToolsViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.tools) { tool in
                Button(action: { viewModel.openTool(tool) }) {
                    HStack {
                        Image(systemName: tool.icon)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)

                        VStack(alignment: .leading) {
                            HStack {
                                Text(tool.title)
                                    .font(.headline)
                                if tool.isNew {
                                    Text("New")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .padding(4)
                                        .background(Color.red.opacity(0.1))
                                        .cornerRadius(4)
                                }
                            }
                            Text(tool.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("智能工具")
        }
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView()
    }
}

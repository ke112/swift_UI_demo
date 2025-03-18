import SwiftUI

struct ToolsView: View {
    let tools = [
        ("扫一扫", "qrcode.viewfinder"),
        ("图片识别", "text.viewfinder"),
        ("翻译", "character.book.closed"),
        ("计算器", "plus.slash.minus"),
        ("日历", "calendar"),
        ("天气", "cloud.sun.fill"),
        ("记事本", "note.text"),
        ("文件", "folder")
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(tools, id: \.0) { tool in
                        VStack {
                            Image(systemName: tool.1)
                                .font(.system(size: 30))
                                .frame(width: 60, height: 60)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            Text(tool.0)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("工具")
        }
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView()
    }
} 
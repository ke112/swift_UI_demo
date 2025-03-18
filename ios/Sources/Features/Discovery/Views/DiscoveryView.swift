import SwiftUI

struct DiscoveryView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<10) { index in
                    NavigationLink(destination: Text("详情 \(index)")) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("发现项目 \(index)")
                        }
                    }
                }
            }
            .navigationTitle("发现")
        }
    }
}

struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryView()
    }
} 

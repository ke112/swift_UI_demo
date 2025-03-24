import Foundation

/// GitHub事件模型
struct GitHubEvent: Decodable, Identifiable {
    let id: String
    let type: String

    // 允许解码器跳过未知字段
    private enum CodingKeys: String, CodingKey {
        case id, type
    }
}

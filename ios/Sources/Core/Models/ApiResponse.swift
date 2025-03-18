import Foundation

/// API响应模型
struct ApiResponse<T: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: T?
}
